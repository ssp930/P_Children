package com.web.root.mybatis.mypageBoard;

import java.util.List;

import com.web.root.board.dto.BoardDTO;
import com.web.root.board.dto.ProgramBoardDTO;

public interface MypageBoardMapper {

	//============================ 최윤희 시작 ===========================================
	
	// (커뮤니티) 마이페이지 해당 아이디 작성 글 페이지 총 카운트
	public int mypageBoardAllCount(String id);
	
	// (커뮤니티) 마이페이지 내가 작성한 페이지 페이징 ex. 1~5 페이지
	public List<BoardDTO> mypageBoardList(BoardDTO myboardDTO);	
	
	// (프로그램) 마이페이지 해당 아이디 작성 글 페이지 총 카운트
	public int mypageBoardProgramAllCount(String id);
	
	// (프로그램) 마이페이지 내가 작성한 페이지 페이징 ex. 1~5 페이지
	public List<ProgramBoardDTO> mypageBoardProgramList(ProgramBoardDTO myboardProgramDTO);
	
	//============================ 최윤희 끝 ===========================================
	
}