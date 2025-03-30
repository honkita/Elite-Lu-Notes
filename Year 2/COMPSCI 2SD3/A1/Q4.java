import java.awt.EventQueue;
import java.util.Timer;
import java.awt.*;
import java.awt.event.*;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import javax.swing.JLabel;

@SuppressWarnings("serial")
public class Q4 extends JFrame {

	
	private boolean trackTime = false;
	private final String frequency = "Current Frequency: %d";
	private int frequencyValue = 108; //lowest is 88
	private JPanel contentPane = new JPanel();
	private final JPanel radioPanel = new JPanel();
	private final JButton scanButton = new JButton("SCAN");
	private final JButton lockButton = new JButton("LOCK");
	private final JButton resetButton = new JButton("RESET");
	JLabel frequencyLabel = new JLabel(String.format(frequency, frequencyValue));
	private Thread time;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Q4 frame = new Q4();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	public void reset() {
		trackTime = false;
		scanButton.setEnabled(true);
		lockButton.setEnabled(false);
		frequencyValue = 108;
		frequencyLabel.setText(String.format(frequency, frequencyValue));
	}

	/**
	 * Create the frame.
	 */
	public Q4() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		JButton onOffButton = new JButton("ON");
		onOffButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (!radioPanel.isVisible()) {
					onOffButton.setText("OFF");
					radioPanel.setVisible(true);
					reset();
				} else {
					onOffButton.setText("ON");
					if (time != null) time.stop();
					radioPanel.setVisible(false);
				}

			}
		});
		onOffButton.setBounds(6, 6, 117, 29);
		contentPane.add(onOffButton);

		radioPanel.setBackground(new Color(146, 103, 103));
		radioPanel.setBounds(0, 45, 450, 201);
		contentPane.add(radioPanel);
		radioPanel.setLayout(null);
		radioPanel.setVisible(false);

		scanButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				lockButton.setEnabled(true);
				scanButton.setEnabled(false);
				trackTime = true;
				time = new Thread() {
					public void run() {
						for (;;) {
							if (trackTime && frequencyValue > 88) {
								try {
									sleep(500);
									frequencyValue--;
									
								} catch (Exception e) {
									System.out.println("BROKEN");
									System.exit(1);
								}
								frequencyLabel.setText(String.format(frequency, frequencyValue));
							} else if (frequencyValue <= 88){					
								lockButton.setEnabled(false);
							}
						}
					}
				};
				time.start();
			}
		});
		scanButton.setBounds(6, 5, 117, 29);
		radioPanel.add(scanButton);

		lockButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				lockButton.setEnabled(false);
				scanButton.setEnabled(true);
				trackTime = false;
				
				
			}
		});

		lockButton.setBounds(6, 35, 117, 29);
		radioPanel.add(lockButton);

		resetButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				time.stop();
				reset();
			}
		});
		
		resetButton.setBounds(6, 65, 117, 29);
		radioPanel.add(resetButton);
		frequencyLabel.setForeground(Color.WHITE);

		frequencyLabel.setBounds(195, 10, 210, 16);
		radioPanel.add(frequencyLabel);

	}
}
