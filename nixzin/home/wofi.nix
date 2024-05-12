{
	programs.wofi = {
		enable = true;
		style = ''
		* {
		    font-family: "JetBrainsMono";
		}
		  
		window {
			margin: 1px;
			border: 15px solid #7aa2f7;
			border-radius: 15px 15px 15px 15px;
			border-color: #A6ADC8
		}
	  
		#input {
			margin: 5px;
			border-radius: 0px;
			border: none;
			border-bottom: 0px solid black;
			background-color: #24283b;
			color: white;
		}
	  
		#inner-box {
			margin: 5px;
		    background-color: #24283b;
		}
	  
		#outer-box {
			margin: 3px;
			padding: 20px;
			background-color: #24283b;
			border-radius: 10px 10px 10px 10px;
		}
		  
		#text {
			margin: 5px;
			color: white;
		}
		  
		#entry:selected {
			background-color: #151718;
		}
		  
		#text:selected {
			text-decoration-color: white;
		}
		'';
	};
}
