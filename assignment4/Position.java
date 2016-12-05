package assignment;

public class Position {
	private int posid;
	private String title;
	
	/*
	 * Constructs an empty Position object
	 */
	public Position() {}
	
	/*
	 * Get id of a Position
	 * @return the id
	 */
	public int getPosid() {
		return this.posid;
	}
	/*
	 * Set the id of a Position
	 * @param id
	 */
	public void setPosid(int id) {
		this.posid = id;
	}
	
	/*
	 * Get title of the Position
	 * @return title
	 */
	public String getTitle() {
		return this.title;
	}
	/*
	 * Set the Position's title
	 * @param title
	 */
	public void setTitle(String t) {
		this.title = t;
	}
}
