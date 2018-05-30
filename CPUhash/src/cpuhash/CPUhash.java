/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpuhash;

import cpuhash.functions.*;
import cpuhash.io.*;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;

/**
 * Hashing on CPU using java built in functions
 * @author Zhuowen Fang
 */
public class CPUhash {

    private static final long MEGABYTE = 1024L * 1024L;
    private static int n[] = new int[]{1,5,10,50,100,200,500,1000,2000,3500,5000,8000,10000,12000,15000,18000,20000,35000,50000,80000,100000,150000,200000,350000,500000};
    //private static int n = 1;
    private static int ite = 1;
    

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws NoSuchAlgorithmException, IOException {
        /*
        File csv = new File("result/CPU.csv");
        BufferedWriter bw = new BufferedWriter(new FileWriter(csv, true));
        bw.write("Hash times,Memory usage(bytes),Memory usage(MB),Runtime(ns),Hashes per second(h/s)");
        bw.newLine();
        bw.close();
        */
        for (int i = 0; i < n.length; i++) {
            for (int j = 0; j < ite; j++) {
                hash(i);
            }
        }

    }
    
    public static void hash(int datai) throws NoSuchAlgorithmException, IOException{
        HashData hd = new HashData();
        hd.setData("data/1.txt");
        String data = hd.getData();

        Sha256 test = new Sha256();
        System.out.println("File length: " + hd.getLength());
        System.out.println(data);
        System.out.println("Hash result: " + test.hash(data));
        
        // Get the Java runtime
        Runtime runtime = Runtime.getRuntime();
        // Run the garbage collector
        runtime.gc();
        // Calculate initial memory usage
        long startMem = runtime.totalMemory() - runtime.freeMemory();
        System.out.println("Max memory: " + runtime.maxMemory());
        System.out.println("Memory>  Total: " + runtime.totalMemory() + "  Free: " + runtime.freeMemory() + "  Used: " + startMem);

        // Get start time
        long startTime = System.nanoTime();

        for (int i=0; i<n[datai]; i++) {
            test.hash(data);
        }
        
        // Get stop time
        long stopTime = System.nanoTime();
        System.out.println("Runtime: " + (stopTime - startTime) + " nanosecond");

        // Calculate final memory usage
        long endMem = runtime.totalMemory() - runtime.freeMemory();
        System.out.println("Memory>  Total: " + runtime.totalMemory() + "  Free: " + runtime.freeMemory() + "  Used: " + endMem);
        System.out.println("Hash result: " + test.hash(data));
        System.out.println("Memory usage in bytes: " + (endMem - startMem));
        long memMB = bytesToMegabytes(endMem - startMem);
        System.out.println("Memory usage in megabytes: " + memMB);
        double h = n[datai] * 1000000000.0 / (stopTime-startTime);
        System.out.println(h + " Hashes/s");
        //Result rslt = new Result();
        //rslt.setResult(n[datai], stopTime - startTime, endMem - startMem, memMB, h);
    }

    public static long bytesToMegabytes(long bytes) {
        return bytes / MEGABYTE;
    }
}
