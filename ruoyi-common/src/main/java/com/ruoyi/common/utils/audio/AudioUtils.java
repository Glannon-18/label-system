package com.ruoyi.common.utils.audio;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;
import java.io.File;
import java.io.IOException;

/**
 * 音频处理工具类
 */
public class AudioUtils {
    
    /**
     * 获取WAV音频文件时长（秒）
     * 
     * @param file 音频文件
     * @return 时长（秒）
     * @throws UnsupportedAudioFileException 不支持的音频文件格式
     * @throws IOException IO异常
     */
    public static double getWavDuration(File file) throws UnsupportedAudioFileException, IOException {
        AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(file);
        AudioFormat format = audioInputStream.getFormat();
        long frames = audioInputStream.getFrameLength();
        double durationInSeconds = (frames + 0.0) / format.getFrameRate();
        audioInputStream.close();
        return durationInSeconds;
    }
    
    /**
     * 获取WAV音频文件时长（秒）
     * 
     * @param filePath 音频文件路径
     * @return 时长（秒）
     * @throws UnsupportedAudioFileException 不支持的音频文件格式
     * @throws IOException IO异常
     */
    public static double getWavDuration(String filePath) throws UnsupportedAudioFileException, IOException {
        return getWavDuration(new File(filePath));
    }
}