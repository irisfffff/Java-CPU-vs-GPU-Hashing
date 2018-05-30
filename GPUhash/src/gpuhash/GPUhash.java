/*
 * JOCL - Java bindings for OpenCL
 * 
 * Copyright 2009 Marco Hutter - http://www.jocl.org/
 */
package gpuhash;

import static org.jocl.CL.*;

import org.jocl.*;

import gpuhash.functions.*;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

/**
 * GPUhash
 *
 * @author Zhuowen Fang
 */
public class GPUhash {

    /**
     * The source code of the OpenCL program to execute
     */
    private static int[] n = new int[]{1, 5, 10, 50, 100, 200, 500, 1000, 2000, 3500, 5000, 8000, 10000, 12000,
        15000, 18000, 20000, 35000, 50000, 80000, 100000, 150000, 200000, 350000, 500000};
    private static int ite = 5;

    public static void main(String args[]) throws IOException {
        /*
        File csv = new File("result/GPU.csv");
        BufferedWriter bw = new BufferedWriter(new FileWriter(csv, true));
        bw.write("Hash times,Memory usage(bytes),Memory usage(MB),Runtime(ns),Hashes per second(h/s)");
        bw.newLine();
        bw.close();
        */
        Sha256 sha256 = new Sha256();
        sha256.setData("data/3.txt");
        for (int i = 0; i < 1; i++) {
            for (int j = 0; j < ite; j++) {
                sha256.init(2048, n[i]);
                sha256.crypt(n[i]);
            }
        }

    }
}
