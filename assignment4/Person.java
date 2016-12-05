package assignment;

public class Person {
	private int pid;
	private String name;
	
	/*
	 * Constructs an empty Person object
	 */
	public Person() {}
	
	/*
	 * Get id of the Person
	 * @return the id
	 */
	public int getPid() {
		return this.pid;
	}
	/*
	 * Set id of a Person
	 * @param id 
	 */
	public void setId(int id) {
		this.pid = id;
	}
	
	/*
	 * Get name of the Person
	 * @return the name
	 */
	public String getName() {
		return this.name;
	}
	/*
	 * Set name of a Person
	 * @param name 
	 */
	public void setName(String name) {
		this.name = name;
	}
}
