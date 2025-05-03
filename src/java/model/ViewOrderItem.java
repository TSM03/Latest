package model;

public class ViewOrderItem {

   private String title;
    private int quantity;
    private double price;
    private String imageUrl;

    // Constructor
    public ViewOrderItem(String title, int quantity, double price, String imageUrl) {
        this.title = title;
        this.quantity = quantity;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    // Getters
    public String getTitle() {
        return title;
    }

    public int getQuantity() {
        return quantity;
    }

    public double getPrice() {
        return price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

}
