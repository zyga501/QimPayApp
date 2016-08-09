package cn.qmpos.entity;

public class Cardinfos {
	// "openAcctId":"6212260200012757767",
	// "openBranchId":" ",
	// "openBankId":"icbc",
	// "openAreaId":"",
	// "openAcctName":"徐丽红",
	// "isDefault":"Y",
	// "openProvId":"",
	// "liqCardId":"CARD150512000052",
	// "openBankName":"工商银行",
	// "openBranchName":" "
	private String openAcctId;
	private String openBranchId;
	private String openBankId;
	private String openAreaId;
	private String openAcctName;
	private String isDefault;
	private String openProvId;
	private String liqCardId;
	private String openBankName;
	private String openBranchName;

	public Cardinfos(String openAcctId, String openAcctName, String isDefault,
			String liqCardId, String openBankName) {
		super();
		this.openAcctId = openAcctId;
		this.openAcctName = openAcctName;
		this.isDefault = isDefault;
		this.liqCardId = liqCardId;
		this.openBankName = openBankName;
	}

	public String getOpenAcctId() {
		return openAcctId;
	}

	public void setOpenAcctId(String openAcctId) {
		this.openAcctId = openAcctId;
	}

	public String getOpenBranchId() {
		return openBranchId;
	}

	public void setOpenBranchId(String openBranchId) {
		this.openBranchId = openBranchId;
	}

	public String getOpenBankId() {
		return openBankId;
	}

	public void setOpenBankId(String openBankId) {
		this.openBankId = openBankId;
	}

	public String getOpenAreaId() {
		return openAreaId;
	}

	public void setOpenAreaId(String openAreaId) {
		this.openAreaId = openAreaId;
	}

	public String getOpenAcctName() {
		return openAcctName;
	}

	public void setOpenAcctName(String openAcctName) {
		this.openAcctName = openAcctName;
	}

	public String getIsDefault() {
		return isDefault;
	}

	public void setIsDefault(String isDefault) {
		this.isDefault = isDefault;
	}

	public String getOpenProvId() {
		return openProvId;
	}

	public void setOpenProvId(String openProvId) {
		this.openProvId = openProvId;
	}

	public String getLiqCardId() {
		return liqCardId;
	}

	public void setLiqCardId(String liqCardId) {
		this.liqCardId = liqCardId;
	}

	public String getOpenBankName() {
		return openBankName;
	}

	public void setOpenBankName(String openBankName) {
		this.openBankName = openBankName;
	}

	public String getOpenBranchName() {
		return openBranchName;
	}

	public void setOpenBranchName(String openBranchName) {
		this.openBranchName = openBranchName;
	}

}
