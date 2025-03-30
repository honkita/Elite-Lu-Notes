
import java.util.Iterator;

/**
 *
 * @author elite
 */
public class A1Q3 {

	/**
	 *
	 * @param list
	 */
	public void SelectionSort(DoublyLinkedList list, boolean ascending) {
		int asc = 1;
		if (!ascending)
			asc = -1;
		DoublyLinkedList p = list;
		Node temp = p.head;

		while (temp != null) {
			Node current = temp; // current node for swapping
			Node swap = temp;
			Node other = temp.next;
			while (other != null) {
				if (other.value * asc < swap.value * asc) {
					swap = other;
				}
				other = other.next;

			}
			temp = temp.next;
			p.swap(current, swap);

		}

	}

	/**
	 * @param args the command line arguments
	 */
	public static void main(String[] args) {
		// TODO code application logic here
		DoublyLinkedList list = new DoublyLinkedList();
		list.addValue(1672);
		list.addValue(172);
		list.addValue(16123);
		list.addValue(12);
		list.addValue(97);
		list.addValue(98);
		list.addValue(94);
		list.addValue(92);

		list.printer();
		System.out.println("\n\n");
		A1Q3 s = new A1Q3();
		s.SelectionSort(list, true);
		list.printer();
	}

}

class DoublyLinkedList implements Iterable<Integer> {

	Node head, tail = null;

	public void addValue(int value) {
		Node temp = new Node(value);
		if (head == null) {
			head = tail = temp;
			head.prev = null;
			tail.next = null;
		} else {
			tail.next = temp;
			temp.prev = tail;
			tail = temp;
			tail.next = null;

		}
	}

	/**
	 * This is the swap method that is used to swap nodes
	 * 
	 * @param current
	 * @param swap
	 */
	public void swap(Node current, Node swap) {
		if (current != swap) { // checks if the nodes are the same, because if they are the same, swapping is
								// pointless

			head = miniSwap(swap, current, head);
			tail = miniSwap(swap, current, tail);
			

			Node[] list = swapper(swap.next, current.next);
			swap.next = list[0];
			current.next = list[1];

			if (current != tail)
				current.next.prev = current;
			if (swap != tail)
				swap.next.prev = swap;

			list = swapper(swap.prev, current.prev);
			swap.prev = list[0];
			current.prev = list[1];

			if (swap != head)
				swap.prev.next = swap;
			if (current != head)
				current.prev.next = current;

		}

	}

	/**
	 * Mini swap for the head and tail
	 * @param n1
	 * @param n2
	 * @param headOrTail
	 * @return
	 */
	public Node miniSwap(Node n1, Node n2, Node headOrTail) {
		if (n1 == headOrTail) {
			headOrTail = n2;
		} else if (n2 == headOrTail) {
			headOrTail = n1;
		}
		return headOrTail;
	}
	
	public Node[] swapper(Node n1, Node n2) {
		Node temp = n1;
		n1 = n2;
		n2 = temp;
		Node[] list = {n1, n2};
		return list;
	}

	public void printer() {
		if (head == null) {
			System.out.println("null");
		} else {
			Node nod = head;
			while (nod != null) {
				System.out.println(nod.value);
				nod = nod.next;
			}

		}
	}

	@Override
	public Iterator iterator() {
		throw new UnsupportedOperationException("Not supported yet."); // Generated from
																		// nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
	}

}

class Node {

	int value;
	Node next;
	Node prev;

	Node(int value) {
		this.value = value;
	}

}