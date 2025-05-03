package model;

public class ShippingInfo {
    private String fullName;
    private String email;
    private String mobile;
    private String fullAddress;
    private String paymentMethod;
    
    public ShippingInfo(String fullName, String email, String mobile, String fullAddress, String paymentMethod) {
        this.fullName = fullName;
        this.email = email;
        this.mobile = mobile;
        this.fullAddress = fullAddress;
        this.paymentMethod = paymentMethod;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public String getMobile() {
        return mobile;
    }

    public String getFullAddress() {
        return fullAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }
}