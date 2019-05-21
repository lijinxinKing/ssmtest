/**
 * synchronized关键字
 * 同步粒度问题
 * 尽量在商业开发中避免同步方法。使用同步代码块。 细粒度解决同步问题。
 * 可以提高效率。
 */
package concurrent.t01;

import org.junit.Test;

public class Test_12 {
	// 同步方法 不建议同步方法 ， 不管是否需要同步 直接加锁
	@Test
	synchronized void m1(){
		// 前置逻辑
		System.out.println("同步逻辑");
		// 后置逻辑
	}
	// 同步代码块
	@Test
	void m2(){
		// 前置逻辑
		synchronized (this) {
			System.out.println("同步逻辑");
		}
		// 后置逻辑
	}
	
}