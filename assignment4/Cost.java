package assignment;

public class Cost {
	private PayPeriod during;
	private BenefitPlan costsAllows;
	private Position costsAllowedFor;
	private double employeeCost;
	private double employerSubsidy;
	
	public Cost() {}
	
	public PayPeriod getDuring() {
		return this.during;
	}
	public void setDuring(PayPeriod pp) {
		this.during = pp;
	}
	
	public BenefitPlan getCostsAllows() {
		return this.costsAllows;
	}
	public void setCostsAllows(BenefitPlan bp) {
		this.costsAllows = bp;
	}
	
	public Position getCostsAllowedFor() {
		return this.costsAllowedFor;
	}
	public void setCostsAllowedFor(Position p) {
		this.costsAllowedFor = p;
	}
	
	public double getEmployeeCost() {
		return this.employeeCost;
	}
	public void setEmployeeCost(double e) {
		this.employeeCost = e;
	}
	
	public double getEmployerSubsidy() {
		return this.employerSubsidy;
	}
	public void setEmployerSubsidy(double e) {
		this.employerSubsidy = e;
	}
}
