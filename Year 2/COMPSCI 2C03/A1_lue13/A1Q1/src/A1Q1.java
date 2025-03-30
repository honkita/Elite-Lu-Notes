
/*
 */
//package a1q1;

import java.util.Iterator;
import java.util.Scanner;

/**
 *
 * @author Elite Lu
 */
public class A1Q1 {

	/**
	 *
	 * @param a
	 * @param q
	 * @return
	 */
	public boolean brackets(String a, Stack<Character> q) {
		for (int i = 0; i < a.length(); i++) {
			if (a.charAt(i) == '(') {
				q.push(a.charAt(i));
			} else if (a.charAt(i) == ')') {
				if (q.size() == 0) {
					return false;
				} else {
					q.pop();
				}
			}

		}
		return q.isEmpty();
	}

	/**
	 * @param args the command line arguments
	 */
	public static void main(String[] args) {
		// TODO code application logic here
		A1Q1 a1 = new A1Q1();
		Scanner keyboard = new Scanner(System.in);
		System.out.print("Enter in your equation: ");
		String a = keyboard.nextLine();
		Stack<Character> q = new Stack<Character>();
		System.out.println(a1.brackets(a, q));
	}

}

/**
 *
 */
class Stack<T> implements Iterable<T> {

	Node<?> head, tail;

	Stack() {
		head = tail = null;
	}

	private int size = 0;

	public void push(T value) {
		if (head == null) {
			head = new Node<T>(value);

		} else {
			Node p = new Node<T>(value);
			p.next = head;
			head = p;
		}
		size++;
	}

	public T pop() {
		// check if the list is null
		if (head == null) {
			return null;
		} else {
			T value = (T) head.value;
			head = head.next;
			size--;
			return value;
		}

	}

	public void printer() {
		if (head == null) {
			System.out.println("null");
		} else {
			Node<T> nod = (Node<T>) head;
			while (nod != null) {
				System.out.println(nod.value);
				nod = nod.next;
			}

		}
	}

	public boolean isEmpty() {
		return (size == 0);
	}

	public int size() {
		return size;
	}

	@Override
	public Iterator<T> iterator() {
		throw new UnsupportedOperationException("Not supported yet.");
	}
}

class Node<T> {

	T value;
	Node next;

	Node(T value) {
		this.value = value;
	}

}