package com.future.blue.board.vo;

public class SearchVO extends PagingVO{
	
	private String title;
	private String contents;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	@Override
	public String toString() {
		return "SearchVO [title=" + title + ", contents=" + contents + "]";
	}


	
}
