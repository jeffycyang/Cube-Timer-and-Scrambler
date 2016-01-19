package code {
	
//import classes from other packages	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.display.SimpleButton;
	import flash.display.Stage; 
	import flash.display.StageAlign; 
	import flash.display.StageScaleMode; 
	import flash.display.MovieClip;
	import flash.display.StageOrientation;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

//create stopwatch class named Timing which is an instance of the class Movieclip
	public class Timing extends MovieClip {
		
//define variables
		//internal timestamps
		public var hrs:Number = 0;
		public var min:Number = 0;
		public var sec:Number = 0;
		public var ms:Number = 0;
		//displayed timestamps
		public var hrss:String = "00";
		public var mins:String = "00";
		public var secs:String = "00";
		public var mss:String = "000";
		public var counter:String = "00:00:00:000";

		//bool
		public var start_time:Number = 0;
		public var timerun:Boolean = false;
		public var pausedornot:Boolean = true;
		public var resetornot:Boolean = true;
		
		//scramble stamps
		public var term:Number = 0;
		public var prevterm:Number = Math.floor(Math.random() * 6 + 1);
		public var scramblelength:Number = 0;
		public var scramble:String = "";
		
		//declare text field format
		public var timeFormat:TextFormat = new TextFormat();
		public var dummytime:String = "";
		public var scrambleFormat:TextFormat = new TextFormat();
		public var dummyscramble:String = "";

//define events
		public function Timing() {
			//initial time display
			timeFormat.bold = true;
			time_txt.text = "00:00:00:000";
			
			scrambleFormat.bold = true;
			
			//disable text properties of the displayed scramble and time text
			scramble_txt.mouseEnabled = false;
			time_txt.mouseEnabled = false;
			
			//respond to mouse clicks on startstopbutton
			startstopbutton.addEventListener(MouseEvent.CLICK, timeHandler);
			
			//update every frame
			addEventListener(Event.ENTER_FRAME,enterframeHandler);
			
			//do not have flash autoscale
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			
			//align stage top left for proper reference pointing
			stage.align = StageAlign.TOP_LEFT;
			
			//what happens when rotated
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, onRotate);
			
			//what is the initial orientation upon app loading
			switch (stage.orientation) {
				case StageOrientation.DEFAULT :
					portraitView();
					break;
				case StageOrientation.ROTATED_RIGHT :
					landscapeView();
					break;
				case StageOrientation.ROTATED_LEFT :
					landscapeView();
					break;
				case StageOrientation.UPSIDE_DOWN :
					portraitView();
					break;
				}
			}

//what is shown on every frame
		protected function enterframeHandler(event:Event):void {			
			var elapsed_time = getTimer()-start_time;

//scramble code
			if ( scramblelength < 20 ) {
	
				term = Math.floor(Math.random() * 6 + 1);
	
				//if previous term = this term or not
				if ( prevterm == term ) {
					//do nothing
				} else {
				//assign scramble to number
					if ( term == 1 ) {
						scramble = scramble + "U";
						punctuate();
						}
					if ( term == 2 ) {
						scramble = scramble + "F";
						punctuate();
						}
					if ( term == 3 ) {
						scramble = scramble + "R";
						punctuate();
						}
					if ( term == 4 ) {
						scramble = scramble + "D";
						punctuate();
						}
					if ( term == 5 ) {
						scramble = scramble + "B";
						punctuate();
						}
					if ( term == 6 ) {
						scramble = scramble + "L";
						punctuate();
						}
					scramblelength = scramblelength + 1;
					prevterm = term;
					}

				}		

			//if you want scramble to show up all at once do 'if (scramblelength == 20)' then below
			scramble_txt.defaultTextFormat = scrambleFormat;
			scramble_txt.text = scramble;
			
			//calculate and display the time
			if ( timerun ) {
				ms = elapsed_time;
				sec = Math.floor(elapsed_time/1000);
				min = Math.floor(sec/60);
				hrs = Math.floor(min/60);
				mss = String(ms % 1000);
				if (mss.length < 2) {
					mss = "00" + mss;
					} else if (mss.length >= 2 && mss.length < 3) {
					mss = "0" +mss;
				}
				secs = String(sec % 60);
				if (secs.length < 2) {
					secs = "0" + secs;
					}
				mins = String(min % 60);
				if (mins.length < 2) {
					mins = "0" + mins;
					}
				hrss = String(hrs);
				if (hrss.length < 2) {
					hrss = "0" + hrss;
					}
				counter = hrss + ":" + mins + ":" + secs + ":" + mss;
				time_txt.defaultTextFormat = timeFormat;
				time_txt.text = counter;
				}				
			}

//define what happens when clicked

		protected function timeHandler(event:MouseEvent):void {
			if ( pausedornot == true && resetornot == false ) {
				reset();
				resetornot = true;
			} else if ( pausedornot == true && resetornot == true ) {
				restart();
				resetornot = false;
			} else if ( pausedornot == false ) {
				time_txt.text = counter;
				pausing(true);
			}
				
		}

//reset function
		public function reset():void {
			scramble = "";
			scramblelength = 0;
			time_txt.text = "00:00:00:000";
			}

//start or restart function
		public function restart():void {
			start_time = getTimer();
			pausing(false);
			}	

//pausing function
		public function pausing(b:Boolean):void {
			pausedornot = b;
			timerun = !b;
			}
			
//punctuate function			
		public function punctuate():void {
			var randomp = Math.floor(Math.random() * 3 + 1);
			if ( randomp == 1 ) {
				scramble = scramble + " ";
				}
			if ( randomp == 2 ) {
				scramble = scramble + "' ";
				}
			if ( randomp == 3 ) {
				scramble = scramble + "2 ";
				}
			}
			
		//portrait view properties
		public function portraitView():void {
			startstopbutton.x = 159.45;
			startstopbutton.y = 239.95;
			startstopbutton.width = 312.95;
			startstopbutton.height = 471.95;
			
			time_txt.x = 5;
			time_txt.y = 198;
			time_txt.width = 309;
			time_txt.height = 58.35;
			//use dummy to change text dynamically upon reorientation
			dummytime = time_txt.text
			timeFormat.size = 42;
			time_txt.defaultTextFormat = timeFormat;
			time_txt.text = dummytime;
			
			scramble_txt.x = 5;
			scramble_txt.y = 108;
			scramble_txt.width = 309;
			scramble_txt.height = 57.20;
			dummyscramble = scramble_txt.text
			scrambleFormat.size = 20;
			scramble_txt.defaultTextFormat = scrambleFormat;
			scramble_txt.text = dummyscramble;
			}
			
		//landscape view properties
		public function landscapeView():void {
			startstopbutton.x = 238.6;
			startstopbutton.y = 160;
			startstopbutton.width = 475;
			startstopbutton.height = 314;
			
			time_txt.x = 5;
			time_txt.y = 160;
			time_txt.width = 464;
			time_txt.height = 100;
			dummytime = time_txt.text;
			timeFormat.size = 64;
			time_txt.defaultTextFormat = timeFormat;
			time_txt.text = dummytime;
			
			scramble_txt.x = 5;
			scramble_txt.y = 55;
			scramble_txt.width = 470;
			scramble_txt.height = 150;
			dummyscramble = scramble_txt.text
			scrambleFormat.size = 25;
			scramble_txt.defaultTextFormat = scrambleFormat;
			scramble_txt.text = dummyscramble;
			}
		
		//cases for reorienting
		public function onRotate(e:StageOrientationEvent):void {
			switch (e.afterOrientation) {
				case StageOrientation.DEFAULT :
					portraitView();
					break;
				case StageOrientation.ROTATED_RIGHT :
					landscapeView();
					break;
				case StageOrientation.ROTATED_LEFT :
					landscapeView();
					break;
				case StageOrientation.UPSIDE_DOWN :
					portraitView();
					break;
				}
			}
			
	}
}