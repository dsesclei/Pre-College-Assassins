// JavaScript Document
		jQuery(document).ready(function() {
			$('#countdown_dashboard').countDown({
				targetDate: {
					'day': 		23,
					'month': 	7,
					'year': 	2011,
					'hour': 	23,
					'min': 		59,
					'sec': 		59					
					},
					omitWeeks: true
			});
		});
