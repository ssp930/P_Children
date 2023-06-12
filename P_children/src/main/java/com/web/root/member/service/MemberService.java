package com.web.root.member.service;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;
import javax.servlet.http.HttpSession;

import org.springframework.ui.Model;

import com.web.root.kakaoPay.dto.ItemDTO;
import com.web.root.member.dto.MemberDTO;
import com.web.root.member.dto.MemberDTO;


public interface MemberService {
	
	//============================ 임청규 시작 ===========================================
	public MemberDTO member_information(String id);
	public void modify_save(HttpServletRequest request);
	public void member_leave_save(HttpServletRequest request);
	public void deleteMember(Model model, HttpServletRequest request);
	
	public int userCheck(HttpServletRequest request);
	
	public void userInfo(String id, Model model);
	
	public void memberInfo(Model model, int num);
	public void manager_board(Model model, int num);
	public void member_board(Model model, int num);
	public void manager_qna(Model model, int num);

	//============================ 임청규 끝 ===========================================
	
	
	//============================ 박성수 시작 ===========================================
	
	public int registHost(MemberDTO dto, Model model);

	public String getHostInfo(String id);
	
	String checkEmail(String email);
	
	int sendEmail(String email);
	
	public String getkakaoToken(String code, String tokenurl) throws IOException;
	
	public int registKakaoUser(String token, String kakaoidurl, HttpSession session) throws IOException;
	
	public String kakaoLogout(String token, String kakaologouturl);
	
	public String readyKakaoPay(String adminKey, String contentType, String kakaoPayReadyUrl, ItemDTO itemDTO, HttpSession session);	
	
	public void kakaoPaymentApprove(String kakaoPaymentApproveUrl, String adminKey, String pg_token, HttpSession session);
	
	public void getkakaoPaymentApproveList(int num, HttpServletRequest request, Model model);
			 
	public void selectKakaoPaymentOrderInfo(String kakaoPaymentOrderUrl, String adminKey, Model model, HttpServletRequest request);
	
	public void kakaoPaymentCancel(String kakaoPaymentCancelUrl, String adminKey, String contentType,
			HttpServletRequest request, Model model);
	
	
	//============================ 박성수 끝 ===========================================

	
	
	
	
	//============================ 최윤희 시작 ===========================================
	
	
	// 아이디 찾기
	public int findUserId(HttpServletRequest request, Model model);
	
	// 비밀번호 찾기
	public int findUserPwd(HttpServletRequest request, Model model);
	
	// 비밀번호 찾기 메일 인증
	public int sendFindPwdEmailCode(String email);
	
	// 비밀번호 수정
	public void userUpdatePwd(MemberDTO dto);
	
	
	
	
	
	
	
	//============================ 최윤희 끝 ===========================================
	
}
