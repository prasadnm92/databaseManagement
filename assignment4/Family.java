package assignment;

import java.util.ArrayList;

public class Family {
	private BenefitPlan fbpid;
	private ArrayList<FamilyRelationship> includes;
	
	public Family() {}
	
	public BenefitPlan getFbpid() {
		return this.fbpid;
	}
	public void setFbpid(BenefitPlan bp) {
		this.fbpid = bp;
	}
	
	public ArrayList<FamilyRelationship> getIncludes() {
		return this.includes;
	}
	public void setIncludes(ArrayList<FamilyRelationship> i) {
		this.includes = i;
	}
	public void addIncludes(FamilyRelationship i) {
		this.includes.add(i);
	}
	public void addAllIncludes(ArrayList<FamilyRelationship> i) {
		this.includes.addAll(i);
	}
}
