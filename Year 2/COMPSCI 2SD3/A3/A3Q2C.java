import java.awt.EventQueue;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import java.awt.Choice;
import java.awt.List;
import java.awt.Button;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JComboBox;
import javax.swing.JLabel;

public class A3Q2C extends JFrame {

	private int currentCustomers = 0;
	private final int customers = 2;
	private int first = -1;
	private int second = -1;
	private JPanel contentPane;
	private JButton pump0prepay = new JButton("Prepay");
	private JButton pump1prepay = new JButton("Prepay");
	private JButton pump2prepay = new JButton("Prepay");
	private JButton pump0 = new JButton("Pump");
	private JButton pump1 = new JButton("Pump");
	private JButton pump2 = new JButton("Pump");
	private JComboBox<Integer> paymenttype0 = new JComboBox<Integer>();
	private JComboBox<Integer> paymenttype1 = new JComboBox<Integer>();
	private JComboBox<Integer> paymenttype2 = new JComboBox<Integer>();
	private JLabel prepaid0 = new JLabel("Selected gas: ");
	private JLabel prepaid1 = new JLabel("Selected gas: ");
	private JLabel prepaid2 = new JLabel("Selected gas: ");

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					A3Q2C frame = new A3Q2C();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	
	public void disablePrepaid() {
		currentCustomers++;
		if (currentCustomers >= customers) {
			paymenttype0.setEnabled(false);
			paymenttype1.setEnabled(false);
			paymenttype2.setEnabled(false);
			pump0prepay.setEnabled(false);
			pump1prepay.setEnabled(false);
			pump2prepay.setEnabled(false);
		}	
		if (first == 0) pump0.setEnabled(true);
		if (first == 1) pump1.setEnabled(true);
		if (first == 2) pump2.setEnabled(true);
	}
	
	private void priorities(int i) {
		if (first == -1) {
			first = i;
		} else if (second == -1) {
			second = i;
		}
	}
	
	private void redoPriorities() {
		currentCustomers--;
		first = second;
		second = -1;
		refactor();
	}
	
	private void refactor() {
		if (first == 0) {
			pump0.setEnabled(true);
			first();
			second();
		}
		if (first == 1) {
			pump1.setEnabled(true);
			zero();
			second();
		}
		if (first == 2) {
			pump2.setEnabled(true);
			zero();
			first();
		}
	}
	
	private void zero() {
		pump0prepay.setEnabled(true);
		paymenttype0.setEnabled(true);
	}
	
	private void first() {
		pump1prepay.setEnabled(true);
		paymenttype1.setEnabled(true);
	}
	
	private void second() {
		pump2prepay.setEnabled(true);
		paymenttype2.setEnabled(true);
	}
	
	/**
	 * Create the frame.
	 */
	public A3Q2C() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		prepaid0.setBounds(0, 80, 120, 16);
		contentPane.add(prepaid0);
		
		prepaid1.setBounds(150, 80, 120, 16);
		contentPane.add(prepaid1);
		
		prepaid2.setBounds(300, 80, 120, 16);
		contentPane.add(prepaid2);
		
		pump0prepay.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump0prepay.setEnabled(false);
				prepaid0.setText("Selected gas: " + paymenttype0.getSelectedItem().toString());
				paymenttype0.setEnabled(false);
				priorities(0);
				disablePrepaid();
			}
		});
		pump0prepay.setBounds(0, 50, 120, 29);
		contentPane.add(pump0prepay);
		
		pump1prepay.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump1prepay.setEnabled(false);
				prepaid1.setText("Selected gas: " + paymenttype1.getSelectedItem().toString());
				paymenttype1.setEnabled(false);
				priorities(1);
				disablePrepaid();
			}
		});
		pump1prepay.setBounds(150, 50, 120, 29);
		contentPane.add(pump1prepay);
		
		pump2prepay.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump2prepay.setEnabled(false);
				prepaid2.setText("Selected gas: " + paymenttype2.getSelectedItem().toString());
				paymenttype2.setEnabled(false);
				priorities(2);
				disablePrepaid();
			}
		});
		pump2prepay.setBounds(300, 50, 120, 29);
		contentPane.add(pump2prepay);
		
		paymenttype0.setBounds(0, 10, 120, 27);
		paymenttype0.addItem(0);
		paymenttype0.addItem(1);
		contentPane.add(paymenttype0);
		
		
		paymenttype1.setBounds(150, 10, 120, 27);
		paymenttype1.addItem(0);
		paymenttype1.addItem(1);
		contentPane.add(paymenttype1);
		
		
		paymenttype2.setBounds(300, 10, 120, 27);
		paymenttype2.addItem(0);
		paymenttype2.addItem(1);
		contentPane.add(paymenttype2);
		
		pump0.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump0prepay.setEnabled(true);
				prepaid0.setText("Selected gas: ");
				paymenttype0.setEnabled(true);
				redoPriorities();
				pump0.setEnabled(false);
			}
		});
		pump0.setEnabled(false);
		pump0.setBounds(0, 200, 120, 29);
		contentPane.add(pump0);
		
		pump1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump1prepay.setEnabled(true);
				prepaid1.setText("Selected gas: ");
				paymenttype1.setEnabled(true);
				redoPriorities();
				pump1.setEnabled(false);
			}
		});
		pump1.setEnabled(false);
		pump1.setBounds(150, 200, 120, 29);
		contentPane.add(pump1);
		
		pump2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pump2prepay.setEnabled(true);
				prepaid2.setText("Selected gas: ");
				paymenttype2.setEnabled(true);
				redoPriorities();
				pump2.setEnabled(false);
			}
		});
		pump2.setEnabled(false);
		pump2.setBounds(300, 200, 120, 29);
		contentPane.add(pump2);
		
		
	}
}
