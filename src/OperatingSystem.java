import java.io.*;
import java.util.ArrayList;
/**
 * @author zhangxin
 * @date 2019-09-15
 */


public class OperatingSystem {

    private ArrayList<Integer> imgByteToWrite = new ArrayList<Integer>();

    private void readKernelFromFile(String fileName) {
        File file = new File(fileName);
        InputStream in = null;

        try {
            in = new FileInputStream(file);
            int tempbyte;
            while ((tempbyte = in.read()) != -1) {
                imgByteToWrite.add(tempbyte);
            }
        } catch(IOException e) {
            e.printStackTrace();
            return;
        }
        // 内核代码读取结束后,直接写入0x55aa, 第一扇区只要有0x55aa即可,不必在最后两个字节
        imgByteToWrite.add(0x55);
        imgByteToWrite.add(0xaa);
        imgByteToWrite.add(0xf0);
        imgByteToWrite.add(0xff);
        imgByteToWrite.add(0xff);

    }

    public OperatingSystem() {
        readKernelFromFile("boot.bat");

        int len = 0x168000;
        int curSize = imgByteToWrite.size();
        for (int l = 0; l < len - curSize; l++) {
            imgByteToWrite.add(0);
        }

    }

    public void makeFllopy()   {
        try {
            DataOutputStream out = new DataOutputStream(new FileOutputStream("system.img"));
            for (int i = 0; i < imgByteToWrite.size(); i++) {
                out.writeByte(imgByteToWrite.get(i).byteValue());
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }

    public static void main(String[] args) {
        OperatingSystem op = new OperatingSystem();
        op.makeFllopy();
    }
}