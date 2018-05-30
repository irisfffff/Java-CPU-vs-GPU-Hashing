/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gpuhash.io;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

/**
 * Put performance result into csv file
 * @author Zhuowen Fang
 */
public class Result {
    public void setResult(int n, long runtime, long mem, long memMB, double h) {
        try {
            File csv = new File("result/GPU.csv");
            BufferedWriter bw = new BufferedWriter(new FileWriter(csv, true));
            bw.write(n + "," + mem + "," + memMB + "," + runtime + "," + h);
            bw.newLine();
            bw.close();
        } catch (FileNotFoundException e) {
          e.printStackTrace(); 
        } catch (IOException e) {
          e.printStackTrace(); 
        } 
    }
}
