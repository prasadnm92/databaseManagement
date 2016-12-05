package assignment;

public class BenefitPlan {
	private int bpid;
	private String name;
	private String description;
	private Benefit partOf;
	
	public BenefitPlan() {}
	
	public int getBpid() {
		return this.bpid;
	}
	public void setBpid(int id) {
		this.bpid = id;
	}
	
	public String getName() {
		return this.name;
	}
	public void setName(String n) {
		this.name = n;
	}
	
	public String getDescription() {
		return this.description;
	}
	public void setDescription(String d) {
		this.description = d;
	}
	
	public Benefit getPartOf() {
		return this.partOf;
	}
	public void setPartOf(Benefit b) {
		this.partOf = b;
	}
}
