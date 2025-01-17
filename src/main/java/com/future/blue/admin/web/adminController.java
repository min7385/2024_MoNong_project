package com.future.blue.admin.web;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import com.future.blue.admin.service.IAdminService;
import com.future.blue.admin.vo.CntVO;
import com.future.blue.auth.vo.AuthVO;

@Controller
public class adminController {

	@Autowired
	IAdminService service;
	
	@GetMapping("/admin/main")
	public String adminView(Model model) {
		List<AuthVO> memList = service.loadUserByNum(5);
		model.addAttribute("memList",memList);
		
		List<CntVO> cntList = service.loadProdCnt(3);
		model.addAttribute("cntList",cntList);
		System.out.println(cntList);
		
		return "admin/main";
	}
	
	@GetMapping("/admin/member")
	public String memberView(Model model) {
		List<AuthVO> memList = service.loadUserByNum(null);
		model.addAttribute("memList",memList);
		return "admin/AdminMember";
	}

	@GetMapping("/admin/prod")
	public String prodView(Model model) {
		List<CntVO> cntList = service.loadProdCnt(null);
		model.addAttribute("cntList",cntList);
		return "admin/AdminProd";
	}
	
	@PostMapping("/admin/deleteDo")
	public ResponseEntity<String> deleteDo(@RequestBody String memId) {
		System.out.println(memId);
		service.deleteMember(memId);
		return ResponseEntity.ok("Member with ID " + memId + " has been deleted");
	}
	
}
