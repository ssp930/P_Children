package com.web.root.member.service;

import javax.servlet.http.HttpServletRequest;
<<<<<<< HEAD

import org.springframework.ui.Model;
=======
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import com.web.root.member.dto.MemberDTO;
>>>>>>> branch 'main' of https://github.com/ssp930/P_Children.git

public interface MemberService {
	
	public int userCheck(HttpServletRequest request);
	public void userInfo(String id, Model model);
	
	public void info(String userid, Model model);
	
	public void memberInfo(Model model, int num);
	public void manager_board(Model model, int num);
	public void manager_qna(Model model, int num);

	//============================ 박성수 시작 ===========================================
	String registMember(HttpSession session, MemberDTO dto);

	String getMemberInfo(String id);
	
	String checkEmail(String email);
	
	int sendEmail(String email);
	
	
	//============================ 박성수 끝 ===========================================

	
	//============================ 최윤희 ===========================================
	
	public int userCheck(HttpServletRequest request);
	
	// 아이디 찾기
	public int findUserId(HttpServletRequest request, Model model);
	
	// 비밀번호 찾기
	public int findUserPwd(HttpServletRequest request, Model model);

	

	
	
	// 비밀번호 찾고 비밀번호 수정
	// public void userRePwd(HttpServletRequest request);
	
}
