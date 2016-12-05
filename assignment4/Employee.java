package assignment;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class Employee {
	private int eid;
	private String address;
	private Position servesAs;
	private String email;
	
	private Connection connection;
	
	public Employee(){}
	
	/*
	 * Solution to Q2: Develop a constructor for your Employee Java class that has two parameters:
	 *  the employee id and a connection to the database. Use JDBC to construct the Employee object
	 *  for the employee with the specified id.
	 */
	public Employee(int id, Connection c) throws SQLException {
		String sql = "SELECT address, servesAs, email FROM Employee WHERE eid=?";
		PreparedStatement retrieveEmployee = c.prepareStatement(sql);
		retrieveEmployee.setInt(1, id);
		ResultSet result = retrieveEmployee.executeQuery();
		
		if(result.next()) {
			this.eid = id;
			this.address = result.getString("address");
			this.email = result.getString("email");

			//create a Position object from the position id retrieved from the database
			this.servesAs = new Position();
			PreparedStatement retrievePosition = c.prepareStatement(
					"SELECT * FROM Position WHERE posid=?");
			retrievePosition.setInt(1, result.getInt("servesAs"));
			ResultSet posResult = retrievePosition.executeQuery();
			if(posResult.next()) {
				this.servesAs.setPosid(posResult.getInt("posid"));
				this.servesAs.setTitle(posResult.getString("title"));
			}
			else {
				throw new SQLException("The Position does not exist");
			}
			this.connection = c;
			return;
		}
		throw new SQLException("The Employee with id="+id+" does not exist");
	}
	
	/*
	 * Solution to Q3: Develop a method that changes a benefit plan for an employee. The method has two parameters:
	 *  the type of benefit and the name of the benefit plan. You may assume that these two parameters uniquely
	 *  determine a benefit plan. You have to check that the employee currently has a benefit plan for the benefit
	 *  and that the new benefit plan is allowed for the employee's position. Use JDBC to update the database.
	 * @param bType: Benefit type
	 * @param bpName: BenefitPlan name
	 */
	public void changeBenefitPlan(String bType, String bpName) throws SQLException {
		Connection c = this.connection;
		int employeeId = this.getEid();
		int benefitId = getBenefitId(bType);
		int newBPlanId = getNewBenefitPlan(bType, bpName);
		if(checkIfEmployeeAllowed(newBPlanId)) {
			if(checkIfEmployeeSelelctsBenefit(bType)) {
				String updateBenefit = "UPDATE Selection"
						+ " SET uses=?"
						+ " WHERE selectedBy=?"
						+ " AND selects=?";
				PreparedStatement updateEmployeeBenefit = c.prepareStatement(updateBenefit);
				updateEmployeeBenefit.setInt(1, newBPlanId);
				updateEmployeeBenefit.setInt(2, employeeId);
				updateEmployeeBenefit.setInt(3, benefitId);
				updateEmployeeBenefit.executeUpdate();
			}
			else {
				System.err.println("Employee has not selected a plan that uses Benefit of type "+bType);
				return;
			}
		}
		else {
			System.err.println("Employee's position not allowed for Benefit Plan "+bpName);
			return;
		}
	}
	
	private int getBenefitId(String type) throws SQLException {
		Connection c = this.connection;
		String selectBenefit = "SELECT bid"
				+ " FROM Benefit"
				+ " WHERE type=?";
		PreparedStatement getBenefitId = c.prepareStatement(selectBenefit);
		getBenefitId.setString(1, type);
		ResultSet rs = getBenefitId.executeQuery();
		//assuming that a Benefit of this type exists
		rs.next();
		return rs.getInt(1);
	}
	
	private int getNewBenefitPlan(String bType, String bpName) throws SQLException {
		Connection c = this.connection;
		String newBPlan = "SELECT b.bid, bp.bpid"
				+ " FROM Benefit b, BenefitPlan bp"
				+ " WHERE bp.partOf=b.bid"
				+ " AND b.type=?"
				+ " AND bp.name=?";
		PreparedStatement getNewBPlan = c.prepareStatement(newBPlan);
		getNewBPlan.setString(1, bType);
		getNewBPlan.setString(2, bpName);
		ResultSet newBPlanResult = getNewBPlan.executeQuery();
		if(newBPlanResult.first()) {
			return newBPlanResult.getInt(2);
		}
		else {
			throw new SQLException("Benefit Plan "+bpName+" does not exist");
		}
	}
	
	private boolean checkIfEmployeeAllowed(int newBPlanId) throws SQLException {
		Connection c = this.connection;
		String bPlanPositions = "SELECT allowedFor"
				+ " FROM Permission"
				+ " WHERE allows=?";
		PreparedStatement getAllowedPositions = c.prepareStatement(bPlanPositions);
		getAllowedPositions.setInt(1, newBPlanId);
		ResultSet bPlanPositionsResults = getAllowedPositions.executeQuery();
		ArrayList<Integer> allowedPositions = new ArrayList<>();
		while(bPlanPositionsResults.next()) {
			allowedPositions.add(bPlanPositionsResults.getInt(1));
		}
		if(!allowedPositions.contains(this.servesAs.getPosid())) return false;
		return true;
	}
	
	private boolean checkIfEmployeeSelelctsBenefit(String bType) throws SQLException {
		Connection c = this.connection;
		String selectedBenefits = "SELECT *"
				+ " FROM Selection sel, Benefit b, Employee e"
				+ " WHERE sel.selectedBy=e.eid"
				+ " AND sel.selects=b.bid"
				+ " AND b.type=?";
		PreparedStatement employeeSelectedBenefits = c.prepareStatement(selectedBenefits);
		employeeSelectedBenefits.setString(1, bType);
		ResultSet rs = employeeSelectedBenefits.executeQuery();
		if(rs.next()) return true;
		return false;
	}
	
	/*
	 * Solution to Q4: Develop a method that computes the annual cost to the employee of every benefit plan for a
	 *  specified benefit. The method has two parameters: the benefit id and pay period duration. Only consider
	 *  three durations: week, month and quarter. Return a map that maps each duration to an annual cost.
	 */
	public HashMap<BenefitPlan, Double> computeAnnualCost(int bId, String ppDuration) throws SQLException {
		Connection c = this.connection;
		HashMap<BenefitPlan, Double> result = new HashMap<>();
		ArrayList<BenefitPlan> employeeBPlans = getBPlans(bId);
		int ppId = getPpidForDuration(ppDuration);
		if(ppId==-1) {
        	System.err.println("Given Pay period is not present in the database");
        	System.exit(0);
		}
		
		String costSQL = "SELECT employee"
				+ " FROM Cost"
				+ " WHERE during=?"
				+ " AND costsAllowedFor=?"
				+ " AND costsAllows=?";
        PreparedStatement computeCost = c.prepareStatement(costSQL);
        ResultSet computeCostRS;
        for (BenefitPlan bPlan : employeeBPlans) {
        	computeCost.setInt(1, bPlan.getBpid());
        	computeCost.setInt(2, this.servesAs.getPosid());
        	computeCost.setInt(3, ppId);
        	computeCostRS = computeCost.executeQuery();

            if (computeCostRS.next()) {
                double employeeSubsidy = computeCostRS.getBigDecimal(1).doubleValue();
                if (ppDuration.equalsIgnoreCase("week")) {
                	employeeSubsidy *= 52;
                } else if (ppDuration.equalsIgnoreCase("month")) {
                	employeeSubsidy *= 12;
                } else if (ppDuration.equalsIgnoreCase("quarter")) {
                	employeeSubsidy *= 4;
                }
                result.put(bPlan, employeeSubsidy);
            }
        }
		return result;
	}
	
	private ArrayList<BenefitPlan> getBPlans(int bId) throws SQLException {
		Connection c = this.connection;
		ArrayList<BenefitPlan> result = new ArrayList<>();
		String getBPlans = "SELECT bp.bpid, bp.name, bp.description"
				+ " FROM BenefitPlan bp, Permission p"
				+ " WHERE p.allows=bp.bpid"
				+ " AND p.allowedFor=?"
				+ " AND bp.partOf=?";
		
		PreparedStatement getBenefitPlans = c.prepareStatement(getBPlans);
        getBenefitPlans.setInt(1, this.servesAs.getPosid());
        getBenefitPlans.setInt(2, bId);
        ResultSet rs = getBenefitPlans.executeQuery();
        while (rs.next()) {
        	BenefitPlan bp = new BenefitPlan();
        	bp.setBpid(rs.getInt(1));
        	bp.setName(rs.getString(2));
        	bp.setDescription(rs.getString(3));
        	result.add(bp);
        }
		return result;
	}
	
	private int getPpidForDuration(String dur) throws SQLException {
		Connection c = this.connection;
		String getPpid = "SELECT ppid FROM PayPeriod WHERE duration=?";
		PreparedStatement getPayPeriodId = c.prepareStatement(getPpid);
        getPayPeriodId.setString(1, dur);
        ResultSet rs = getPayPeriodId.executeQuery();
        if (rs.first()) {
            return rs.getInt(1);
        }
        return -1;
	}
	
	public int getEid() {
		return this.eid;
	}
	public void setEid(int id) {
		this.eid = id;
	}
	
	public String getAddress() {
		return this.address;
	}
	public void setAddress(String addr) {
		this.address = addr;
	}
	
	public Position getServesAs() {
		return this.servesAs;
	}
	public void setServesAs(Position serve) {
		this.servesAs = serve;
	}
	
	public String getEmail() {
		return this.email;
	}
	public void setEmail(String e) {
		this.email = e;
	}
	
	public String toString() {
		return "ID\t\t"+ Integer.toString(this.eid) + "\n" +
				"Address\t\t"+ this.address + "\n" +
				"Position\t"+ Integer.toString(this.servesAs.getPosid()) + "\n" +
				"Email\t\t"+ this.email;
	}
}
