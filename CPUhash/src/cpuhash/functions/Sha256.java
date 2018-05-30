/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cpuhash.functions;

import java.security.*;

/**
 * SHA256 hashing functions
 * @author Zhuowen Fang
 */
public class Sha256 {
	// Compute hash value using SHA-256 algorithm
	public static String hash(String data) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		md.update(data.getBytes());
		return bytesToHex(md.digest());
	}
	// Convert value from bytes to hex 
	private static String bytesToHex(byte[] value) {
		StringBuffer hexValue = new StringBuffer();
		for (byte byt : value) {
			hexValue.append(Integer.toString((byt & 0xff) + 0x100, 16).substring(1));
		}
		return hexValue.toString();
	}
	
}
