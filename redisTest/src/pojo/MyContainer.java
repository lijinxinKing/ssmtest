package pojo;

public class MyContainer<T> {

    private long size;

    public long getSize() {
        return size;
    }

    public MyContainer(long size) {
        this.size = size;
    }

    public MyContainer() {
    }

    public void setSize(long size) {
        this.size = size;
    }

}
