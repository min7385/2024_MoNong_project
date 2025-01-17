package com.future.blue.common.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.future.blue.auth.util.JwtUtil;
import com.future.blue.mypage.service.IMypageService;
import com.future.blue.mypage.vo.MypageVO;
import com.future.blue.purchase.service.ChatService;
import com.future.blue.purchase.vo.ChatVO;

/**
 * 파일 업로드 및 다운로드를 처리하는 컨트롤러 클래스
 * 
 * 주요 기능:
 * 1. 파일 다운로드 기능 (/download) - 서버에 있는 파일을 사용자가 다운로드할 수 있도록 제공
 * 2. 파일 업로드 기능 (/multiImgUpload) - 사용자가 다중 이미지를 업로드하고 해당 파일을 서버에 저장
 * 3. 파일 경로 설정 : src/main/resources/config/app.properties  에 작성했음.
 */
@Controller
public class FileController {
	
	// 파일 업로드 경로 - application.properties에 설정된 값 이용
	@Value("#{util['file.upload.path']}")
    private String CURR_IMAGE_PATH;

    // 파일 다운로드 경로 - application.properties에 설정된 값 이용
	@Value("#{util['file.download.path']}")
    private String WEB_PATH;

	@Autowired
	private ChatService chatService;

	@Autowired
	private IMypageService mypageService;
	
    /**
     * 파일 다운로드 메서드
     * 
     * @param imageFileName 다운로드할 파일의 이름
     * @param response HttpServletResponse 객체
     * @throws IOException 파일 접근 중 오류 발생 시 예외 처리
     */
    @RequestMapping("/download")
    public void download(String imageFileName, HttpServletResponse response) throws IOException {
        Path downloadFilePath = Paths.get(CURR_IMAGE_PATH, imageFileName);
        File file = downloadFilePath.toFile();

        // 로컬에서 요청 파일을 찾아서 전달
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "file not found");
            return;  // 파일이 없을 경우 메서드를 종료
        }

        // 캐시 제어 및 파일 다운로드 설정
        response.setHeader("Cache-Control", "no-cache");
        // 인코딩
        String encodedFilename = URLEncoder.encode(imageFileName, StandardCharsets.UTF_8)
                                    .replaceAll("\\+", "%20");

        // 표준에 맞춰 filename*=UTF-8''
        // 만약 구형 브라우저 호환성도 고려한다면, filename=""도 병행
        response.setHeader("Content-Disposition", 
           "attachment; filename*=UTF-8''" + encodedFilename);

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[1024 * 8];
            int count;
            while ((count = in.read(buffer)) != -1) {
                out.write(buffer, 0, count);  // 실시간 전송
            }
        } catch (IOException e) {
            e.printStackTrace();  // 오류 발생 시 스택 추적 출력
        }
    }

    /**
     * 다중 이미지 업로드 메서드
     * 
     * @param req HttpServletRequest 객체 (클라이언트의 업로드 요청 처리)
     * @param res HttpServletResponse 객체 (업로드 후 파일 정보 응답)
     */
    @RequestMapping("/multiImgUpload")
    public void multiImgUpload(HttpServletRequest req, HttpServletResponse res) {
        try {
            String sFileInfo = "";
            String fileName = req.getHeader("file-name");
            String prefix = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            String path = CURR_IMAGE_PATH;

            // 경로가 없으면 디렉토리 생성
            Path directoryPath = Paths.get(path);
            if (!Files.exists(directoryPath)) {
                Files.createDirectories(directoryPath);
            }

            // 서버에 저장될 파일 이름 생성 (UUID 사용)
            String realName = UUID.randomUUID().toString() + "." + prefix;
            Path filePath = directoryPath.resolve(realName);

            // 업로드 파일 저장
            try (InputStream is = req.getInputStream();
                 OutputStream os = new FileOutputStream(filePath.toFile())) {
                byte[] buffer = new byte[1024];
                int read;
                while ((read = is.read(buffer)) != -1) {
                    os.write(buffer, 0, read);
                }
            }

            // 전달 정보 구성
            sFileInfo += "&bNewLine=true";
            sFileInfo += "&sFileName=" + fileName;
            sFileInfo += "&sFileURL=" + WEB_PATH + realName;

            // 응답 전송
            try (PrintWriter print = res.getWriter()) {
                print.print(sFileInfo);
                print.flush();
            }

        } catch (IOException e) {
            e.printStackTrace();  // 오류 발생 시 스택 추적 출력
        }
    }
    

	/**
	 * 단일 파일을 업로드하는 메소드.
	 *
	 * @param photo 업로드할 파일 (MultipartFile 형식)
	 * @return 저장된 파일의 웹 접근 경로
	 * @throws IOException 파일 저장 중 발생할 수 있는 예외 처리
	 */
	public String uploadSingleFile(MultipartFile photo) throws IOException {
	    // 업로드된 파일의 원래 이름 가져오기
	    String fileName = photo.getOriginalFilename();
	    // 파일 확장자 추출 및 소문자로 변환
	    String prefix = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
	    // 파일 저장 경로 설정 (application.properties에서 로드된 값)
	    String path = CURR_IMAGE_PATH;
	    // 저장 경로가 없을 경우 디렉토리 생성
	    Path directoryPath = Paths.get(path);
	    if (!Files.exists(directoryPath)) {
	        Files.createDirectories(directoryPath);
	    }
	    // UUID를 사용하여 고유한 파일 이름 생성
	    String realName = UUID.randomUUID().toString() + "." + prefix;
	    Path filePath = directoryPath.resolve(realName);
	
	    // 파일을 지정된 경로에 저장
	    photo.transferTo(filePath.toFile());
	
	    // 저장된 파일의 웹 접근 경로 반환
	    return WEB_PATH + realName; // WEB_PATH는 미리 정의된 웹 경로
	}
    
	
	/**
	 * @Author : LeeApGil
	 * @Date   : 2024. 12. 23.
	 * @Method : uploadFiles
	 * @return : Map<String,Object>
	 * Purpose :
	 * Description :
	*/
	@ResponseBody
	@PostMapping("/files/upload")
	public Map<String, Object> uploadFiles(
		  @RequestParam("file") MultipartFile uploadImage, ChatVO vo) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		vo.setTmDate(sdf.format(new Date()));
		String imgPath = chatService.insertChatImage(vo
				                             , CURR_IMAGE_PATH
				                             , WEB_PATH, uploadImage);
		Map<String, Object> map = new HashMap<>();
		map.put("message","success");
		map.put("imagePath", imgPath);
		return map;  // map을 json 데이터로 리턴 
	}
	
	@ResponseBody
	@PostMapping("/files/uploadProfile")
	public Map<String, Object> uploadProfile(
			  HttpServletRequest request
			  ,@RequestParam("uploadImage") MultipartFile uploadImage) throws Exception{
		
		String accessToken = JwtUtil.extractToken(request);
	    String memId = JwtUtil.getMemIdFromToken(accessToken);
	    MypageVO userInfo = mypageService.getMyData(memId);
	    
		String imgPath = mypageService.profileUpload(userInfo, CURR_IMAGE_PATH, WEB_PATH, uploadImage);
		Map<String, Object> map = new HashMap<>();
		map.put("message", "success");
		map.put("imagePath", imgPath);
		return map;
	}


}
