package assignment;

public class Dependent {
	private Person hasDependent;
	private Employee dependsOn;
	private FamilyRelationship relatedBy;
	
	public Dependent() {}
	
	public Person getHasDependent() {
		return this.hasDependent;
	}
	public void setHasDependent(Person p) {
		this.hasDependent = p;
	}
	
	public Employee getDependsOn() {
		return this.dependsOn;
	}
	public void setDependsOn(Employee e) {
		this.dependsOn = e;
	}
	
	public FamilyRelationship getRelatedBy() {
		return this.relatedBy;
	}
	public void setRelatedBy(FamilyRelationship rel) {
		this.relatedBy = rel;
	}
}
