package assignment;

public class Selection {
	private Employee selectedBy;
	private Benefit selects;
	private BenefitPlan uses;
	
	public Selection() {}
	
	public Employee getSelectedBy() {
		return this.selectedBy;
	}
	public void setSelectedBy(Employee e) {
		this.selectedBy = e;
	}
	
	public Benefit getSelects() {
		return this.selects;
	}
	public void setSelects(Benefit b) {
		this.selects = b;
	}
	
	public BenefitPlan getUses() {
		return this.uses;
	}
	public void setUses(BenefitPlan bp) {
		this.uses = bp;
	}
}
