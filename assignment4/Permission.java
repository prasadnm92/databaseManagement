package assignment;

public class Permission {
	private BenefitPlan allows;
	private Position allowedFor;
	
	public Permission() {}
	
	public BenefitPlan getAllows() {
		return this.allows;
	}
	public void setAllows(BenefitPlan bp) {
		this.allows = bp;
	}
	
	public Position getAllowedFor() {
		return this.allowedFor;
	}
	public void setAllowedFor(Position p) {
		this.allowedFor = p;
	}
}
