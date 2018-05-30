/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpuhash.io;

import java.io.File;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

/**
 * To get hash data from source file
 * @author Zhuowen Fang
 */
public class HashData {

    private String data = "";
    private long lth = 0;
    
    public void setData(String filename) throws IOException {
        File file = new File(filename);
        lth = file.length();
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
    
    public String getData() {
        return data;
    }
    
    public long getLength() {
        return lth;
    }
}
