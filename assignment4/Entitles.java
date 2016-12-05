package assignment;

public class Entitles {
	private Benefit entitledTo;
	private Position entitledBy;
	
	public Entitles() {}
	
	public Benefit getEntitledTo() {
		return this.entitledTo;
	}
	public void setEntitledTo(Benefit b) {
		this.entitledTo = b;
	}
	
	public Position getEntitledBy() {
		return this.entitledBy;
	}
	public void setEntitledBy(Position p) {
		this.entitledBy = p;
	}
}
