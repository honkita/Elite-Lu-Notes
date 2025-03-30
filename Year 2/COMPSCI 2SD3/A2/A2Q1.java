import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;

public class A2Q1 extends JFrame {

	private JPanel contentPane;
	private final JButton thinkButton = new JButton("Think");
	private final JButton cookieButton = new JButton("Cookie");
	private final JButton colaButton = new JButton("Cola");
	private final JLabel actionLabel = new JLabel("Current Action: ");
	private final JLabel servantLabel = new JLabel("Servant Action: ");
	
	private int cookies = 3;
	private int colas = 2;
	

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					A2Q1 frame = new A2Q1();
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
	public A2Q1() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		
		thinkButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				actionLabel.setText("Current Action: Philosopher is thinking");
				servantLabel.setText("Servant Action: ");
			}
		});
		thinkButton.setBounds(6, 72, 117, 29);
		contentPane.add(thinkButton);
		
		
		actionLabel.setBounds(6, 6, 438, 16);
		contentPane.add(actionLabel);
		
		
		servantLabel.setBounds(6, 34, 438, 16);
		contentPane.add(servantLabel);
		
		
		cookieButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(cookies > 1) {
					actionLabel.setText("Current Action: Philosopher took and ate a cookie");
					servantLabel.setText("Servant Action: ");
					cookies--;
				} else {
					actionLabel.setText("Current Action: Philosopher took and ate the last cookie");
					servantLabel.setText("Servant Action: Servant refilled the cookie machine");
					cookies = 3;
				}
			}
		});
		cookieButton.setBounds(6, 107, 117, 29);
		contentPane.add(cookieButton);
		
		
		colaButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(colas > 1) {
					actionLabel.setText("Current Action: Philosopher took and drank a cola");
					servantLabel.setText("Servant Action: ");
					colas--;
				} else {
					actionLabel.setText("Current Action: Philosopher took and drank the last cola");
					servantLabel.setText("Servant Action: Servant refilled the cola machine");
					colas = 2;
				}
			}
		});
		colaButton.setBounds(6, 144, 117, 29);
		contentPane.add(colaButton);
	}
}
