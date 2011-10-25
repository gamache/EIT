var EIT = {
	sections: [ 
		'elite_trophies', 'regular_trophies', 'high_scores', 'recognition_trophies' 
	],
	
	show_all_sections: function () { 
		for (var i=0; i<EIT.sections.length; i++) {
			$(EIT.sections[i]).show();
		}
		return false;
	},
	
	show_section: function (section) {
		$(section).show();
		for (var i=0; i<EIT.sections.length; i++) {
			if (EIT.sections[i] != section) {
				$(EIT.sections[i]).hide();
			}
		}
		return false;
	}
};
