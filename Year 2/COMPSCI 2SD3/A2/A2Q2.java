import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JLabel;

public class A2Q2 extends JFrame {

	private JPanel contentPane;
	private final JButton Open = new JButton("Open Store");
	private final JButton Close = new JButton("Close Store");
	private final JButton addCustomer = new JButton("+ Customer");
	private final JButton minusCustomer = new JButton("- Customer");
	private final JLabel Label = new JLabel("The store is closed");
	private int customers = 0;
	private boolean opened = false;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					A2Q2 frame = new A2Q2();
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
	public A2Q2() {
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 260, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		
		
		
		addCustomer.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(customers < 5) {
					customers++; 
					if(customers == 1) {
						Label.setText("There is " + Integer.toString(customers) + " customer");
					} else {
						Label.setText("There are " + Integer.toString(customers) + " customers");
					}
					
				} 
				if(customers == 5) addCustomer.setEnabled(false);
				minusCustomer.setEnabled(true);
			}
		});
		addCustomer.setBounds(20, 150, 220, 29);
		contentPane.add(addCustomer);
		
		
		minusCustomer.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(customers > 0) {
					customers--; 
					if(customers == 1) {
						Label.setText("There is " + Integer.toString(customers) + " customer");
					} else {
						Label.setText("There are " + Integer.toString(customers) + " customers");
					}
				} 
				if(customers == 0) {
					minusCustomer.setEnabled(false);
					if(opened == false) {
						Open.setEnabled(true);
					}
				}
				if (opened) addCustomer.setEnabled(true);
				
			}
		});
		minusCustomer.setBounds(20, 175, 220, 29);
		contentPane.add(minusCustomer);
		
		
		Open.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addCustomer.setEnabled(true);
				Open.setEnabled(false);
				Close.setEnabled(true);
				opened = true;
				Label.setText("The store is open");
			}
		});
		Open.setBounds(20, 200, 220, 29);
		contentPane.add(Open);
		
		
		Close.setBounds(20, 225, 220, 29);
		Close.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				addCustomer.setEnabled(false);
				Close.setEnabled(false);
				
				opened = false;
				if(customers > 0) {
					Label.setText("Closed but there are customers");
				} else {
					Label.setText("The store is closed");
					Open.setEnabled(true);
				}
				
			}
		});
		contentPane.add(Close);
		
		
		Label.setBounds(19, 32, 335, 62);
		contentPane.add(Label);
		
		addCustomer.setEnabled(false);
		minusCustomer.setEnabled(false);
		Close.setEnabled(false);
	}
}
