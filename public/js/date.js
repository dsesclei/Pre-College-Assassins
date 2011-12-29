// JavaScript Document
		jQuery(document).ready(function() {
			$('#countdown_dashboard').countDown({
				targetDate: {
					'day': 		25,
					'month': 	7,
					'year': 	2011,
					'hour': 	6,
					'min': 		0,
					'sec': 		0					
					},
					omitWeeks: true
			});
		});