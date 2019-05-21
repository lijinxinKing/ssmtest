import org.junit.Test;

import java.util.*;
import java.util.concurrent.*;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class Test_03_Container{
    List<Object> container = new ArrayList<>();

    public void add(Object o){
        this.container.add(o);
    }

    public int size(){
        return this.container.size();
    }
}

class test_container<T>{

}

class test_reentrantLockContainer<T>{
    private int MAX;
    private List<T> container = new ArrayList<>();
    private int count;


    public synchronized int getCount(){
        return count;
    }

    public synchronized void get(){
        try{
            while (getCount() == 0){
                System.out.println("Get Wait");
                this.wait();
            }
        }catch (InterruptedException ex){
            ex.printStackTrace();
        }finally {
            count--;
            container.remove(0);
            this.notifyAll();
        }
    }

    public synchronized void add(){
        try{
            while (getCount() == MAX){
                this.wait();
                System.out.println("Add Wait");
            }
        }catch (InterruptedException ex){
            ex.printStackTrace();
        }finally {
            count++;
            Object o = new Object();
            T t = (T)o;
            container.add(t);
            this.notifyAll();
        }
    }
}

public class redisTest {


    @Test
    public static void main(String []args){
        // 本地线程变量
        // 睡眠阻塞 ，Lock 不可被打断，
        // 生产者 消费者  生产者模式
        test_reentrantLockContainer t = new test_reentrantLockContainer();
        // 十个线程 消费者
        for (int i=0; i<10; i++){
         new Thread(new Runnable() {
               @Override
               public void run() {
                   try {
                       t.add();
                   }finally {

                   }
               }
           },"test get").start();
        }
        // 两个线程 生产者

        for (int i=0;i <2;i++){
            new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        t.get();
                    }finally {

                    }
                }
            },"test add").start();
        }

    }
}



