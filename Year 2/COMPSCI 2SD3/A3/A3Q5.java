import java.awt.EventQueue;
import java.lang.Thread;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JTextPane;
import javax.swing.JLabel;

public class A3Q5 extends JFrame {

	private int num = 0;
	private int next = 0;
	private JTextPane activity = new JTextPane();
	private Thread[] customers = new Thread[4];
	private JPanel contentPane;
	private JButton newCustomer = new JButton("New Customer");
	private JLabel customerInfo = new JLabel("Customers: 0");
	private int[] time = new int[4];
	private boolean[] stop = new boolean[4];
	
	
	public synchronized int ticket() {
		next = next % 4 + 1;
		return next;
	}
	
	public synchronized void getCheese(int ticket) throws InterruptedException {
		activity.setText(activity.getText() + "\n" + "Ticket " + ticket + " has been served.");
		newCustomer.setEnabled(true);
		num--;
		customerInfo.setText("Customers: " + num);
	}
	
	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					A3Q5 frame = new A3Q5();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public A3Q5() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 600, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		
		newCustomer.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int n = ticket();
				num++;
				customerInfo.setText("Customers: " + num);
				activity.setText(activity.getText() + "\nPerson with ticket " + n + " has ordered");
				time[n - 1] = 0;
				stop[n - 1] = true;
				customers[n - 1] = new Thread() {
					
					public void run() {
						for (;;) {
							if(stop[n - 1]) {
								if(time[n - 1] <= 2) {
									try {
										sleep(1000);
										time[n - 1]++;
									} catch (Exception e) {
										System.exit(1);
									}
								} else {
									try {
										getCheese(n);
										stop[n - 1] = false;
									} catch (InterruptedException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
									
								}
							}
							
						}
					}
				};
				customers[n - 1].start();
				if (num >= 4) {
					newCustomer.setEnabled(false);
				}
			}
		});
		newCustomer.setBounds(19, 96, 117, 29);
		contentPane.add(newCustomer);
		
		
		activity.setBounds(213, 33, 250, 205);
		contentPane.add(activity);
		activity.setEnabled(false);
		activity.setText("Activity Log:");
		JScrollPane sp = new JScrollPane(activity); 
		sp.setBounds(213, 33, 250, 205);
		contentPane.add(sp);
		
		customerInfo.setBounds(33, 57, 117, 16);
		contentPane.add(customerInfo);
	}
}
