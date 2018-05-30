/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gpuhash.functions;

import gpuhash.io.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

import static org.jocl.CL.*;

import org.jocl.*;

/**
 * Call SHA256 kernel using JOCL
 * @author Zhuowen Fang
 */
public class Sha256 {

    private static final int SHA256_PLAINTEXT_LENGTH = 64; // 64 Bytes = 512 bits per block
    private static final int SHA256_BINARY_SIZE = 32;
    private static final int SHA256_RESULT_SIZE = 8; // 8 ints = 32 Bytes = 256 bits
    private static final int UINT_SIZE = 4;

    private String data = "";
    private int lth = 0;

    // The platform, device type and device number that will be used
    private static final int platformIndex = 0;
    private static final long deviceType = CL_DEVICE_TYPE_GPU;
    private static final int deviceIndex = 0;

    private static int kpc = 4;
    private String kernelCode = ""; // Kernel source code
    private long kernelLen; // Kernel length
    private cl_command_queue commandQueue;
    private static cl_context context;
    private char[] dataArray;
    private cl_mem dataMem, dataInfo, messageDigest;
    private cl_program program;
    private cl_kernel kernel;
    private long[] global_work_size;
    private long[] local_work_size;
    private int[] datai = new int[3];
    private int[] result;
    private int[] device_info = new int[3];
    
    private static final long MEGABYTE = 1024L * 1024L;

    

    // Set the input string to hash
    public void setData(String filename) throws IOException {
        File file = new File(filename);
        lth = (int) file.length();
        InputStreamReader reader = new InputStreamReader(
                new FileInputStream(file));
        BufferedReader br = new BufferedReader(reader);
        String line = "";
        boolean mark = false;
        line = br.readLine();
        while (line != null) {
            if (!mark) {
                mark = true;
            } else {
                data += "\n";
            }
            data += line;
            line = br.readLine();
        }
        br.close();
        reader.close();

    }

    public void init(int userKpc, int n) throws IOException {

        // Perhaps for input length..?
        kpc = userKpc;

        dataArray = new char[SHA256_PLAINTEXT_LENGTH * kpc];
        dataArray = data.toCharArray();

        //System.out.println("File length: " + lth);
        //System.out.println(dataArray);
        // Obtain the number of platforms
        int numPlatformsArray[] = new int[1];
        clGetPlatformIDs(0, null, numPlatformsArray);
        int numPlatforms = numPlatformsArray[0];

        // Obtain a platform ID
        cl_platform_id platforms[] = new cl_platform_id[numPlatforms];
        clGetPlatformIDs(platforms.length, platforms, null);
        cl_platform_id platform = platforms[platformIndex];

        // Initialize the context properties
        cl_context_properties contextProperties = new cl_context_properties();
        contextProperties.addProperty(CL_CONTEXT_PLATFORM, platform);

        // Obtain the number of devices for the platform
        int numDevicesArray[] = new int[1];
        clGetDeviceIDs(platform, deviceType, 0, null, numDevicesArray);
        int numDevices = numDevicesArray[0];

        // Obtain a device ID 
        cl_device_id devices[] = new cl_device_id[numDevices];
        clGetDeviceIDs(platform, deviceType, numDevices, devices, null);
        cl_device_id device = devices[deviceIndex];

        //clGetDeviceInfo(device,CL_DEVICE_ADDRESS_BITS,12,Pointer.to(device_info),null);
        //System.out.println("Sizes: " + device_info[0]);
        
        // Create a context for the selected device
        cl_context context = clCreateContext(
                contextProperties, 1, new cl_device_id[]{device},
                null, null, null);

        // Create a command-queue, with profiling info enabled
        long properties = 0;
        properties |= CL_QUEUE_PROFILING_ENABLE;
        commandQueue = clCreateCommandQueue(
                context, devices[0], properties, null);

        dataMem = new cl_mem();
        dataInfo = new cl_mem();
        messageDigest = new cl_mem();
        dataMem = clCreateBuffer(context, CL_MEM_READ_ONLY, SHA256_PLAINTEXT_LENGTH * kpc,
                null, null);
        dataInfo = clCreateBuffer(context, CL_MEM_READ_ONLY, UINT_SIZE * 3, null, null);
        messageDigest = clCreateBuffer(context, CL_MEM_WRITE_ONLY, Sizeof.cl_uint * SHA256_RESULT_SIZE * n, null, null);

        // Load kernel code
        load();

        // Create the program from the source code
        program = clCreateProgramWithSource(context,
                1, new String[]{kernelCode}, null, null);
        // Build the program
        clBuildProgram(program, 0, null, null, null, null);

        // Create the kernel
        kernel = clCreateKernel(program, "sha256Kernel", null);
        // Set the arguments for the kernel
        clSetKernelArg(kernel, 0, Sizeof.cl_mem, Pointer.to(dataInfo));
        clSetKernelArg(kernel, 1, Sizeof.cl_mem, Pointer.to(dataMem));
        clSetKernelArg(kernel, 2, Sizeof.cl_mem, Pointer.to(messageDigest));
        
        // Set the work-item dimensions
        global_work_size = new long[]{n};
        local_work_size = new long[]{1};
        
        result = new int[8 * n];
    }

    public void crypt(int n) {
        
        datai[0] = SHA256_PLAINTEXT_LENGTH;
        datai[1] = (int) global_work_size[0];
        datai[2] = lth;

        clEnqueueWriteBuffer(commandQueue, dataInfo, CL_TRUE, 0,
                UINT_SIZE * 3, Pointer.to(datai), 0, null, null);

        clEnqueueWriteBuffer(commandQueue, dataMem, CL_TRUE, 0,
                SHA256_PLAINTEXT_LENGTH * kpc, Pointer.to(dataArray), 0, null, null);

        
        // Get the Java runtime
        Runtime runtime = Runtime.getRuntime();
        // Run the garbage collector
        runtime.gc();
        // Calculate initial memory usage
        long startMem = runtime.totalMemory() - runtime.freeMemory();
        System.out.println("Memory>  Total: " + runtime.totalMemory() + "  Free: " + runtime.freeMemory() + "  Used: " + startMem);
        // Get start time
        long startTime = System.nanoTime();
        
        // Execute the kernel
        clEnqueueNDRangeKernel(commandQueue, kernel, 1, null,
                global_work_size, local_work_size, 0, null, null);
        
        // Read the output data
        clEnqueueReadBuffer(commandQueue, messageDigest, CL_TRUE, 0,
                Sizeof.cl_uint * SHA256_RESULT_SIZE * n, Pointer.to(result), 0, null, null);
        
        long stopTime = System.nanoTime();
        
        // Release kernel, program, and memory objects
        clReleaseMemObject(dataInfo);
        clReleaseMemObject(dataMem);
        clReleaseMemObject(messageDigest);
        clReleaseKernel(kernel);
        clReleaseProgram(program);
        clReleaseCommandQueue(commandQueue);
        clReleaseContext(context);

        /*
        System.out.print("Hash result: ");
        for (int i = 0; i < SHA256_RESULT_SIZE; i++) {
            System.out.printf("%x", result[i]);
        }
        System.out.println();
        */
        
        // Get stop time
        System.out.println("Runtime: " + (stopTime - startTime) + " nanosecond");

        // Calculate final memory usage
        long endMem = runtime.totalMemory() - runtime.freeMemory();
        System.out.println("Memory>  Total: " + runtime.totalMemory() + "  Free: " + runtime.freeMemory() + "  Used: " + endMem);
        
        System.out.println("Memory usage in bytes: " + (endMem - startMem));
        long memMB = bytesToMegabytes(endMem - startMem);
        System.out.println("Memory usage in megabytes: " + memMB);
        double h = n * 1000000000.0 / (stopTime-startTime);
        System.out.println(h + " Hashes/s");
        
        //Result rslt = new Result();
        //rslt.setResult(n, stopTime - startTime, endMem - startMem, memMB, h);
    }

    private void load() throws IOException {
        // Read kernel
        BufferedReader br = new BufferedReader(new FileReader("src/gpuhash/kernel/Sha256.cl"));
        StringBuilder sb = new StringBuilder();
        String line = null;
        while (true) {
            line = br.readLine();
            if (line == null) {
                break;
            }
            sb.append(line + "\n");
        }
        kernelCode = sb.toString();
        kernelLen = kernelCode.length();
    }
    
    public static long bytesToMegabytes(long bytes) {
        return bytes / MEGABYTE;
    }
}
