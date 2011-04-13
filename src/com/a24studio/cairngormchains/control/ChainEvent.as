package com.a24studio.cairngormchains.control {
	import com.a24studio.cairngormchains.chains;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;
	
	/**
	 * This class will use things in the internal chains namespace. Anything that is not declared
	 * as public, private or protected will be inside this namespace.
	 */
	use namespace chains;
	
	/**
	 * Cairngorm event implementation that supports having multiple responders
	 * and chaining of events. This event shouldn't be used directly unless you use
	 * the chainEvents method to create it.
	 * 
	 * @author Petrus Rademeyer
	 * @since 22 April 2011
	 */
	public class ChainEvent extends CairngormEvent {
		/**
		 * Array of responders that will be notified when the command retrieves data or is complete.
		 * 
		 * @var Array
		 */
		chains var arrResponders : Array = [];
		
		/**
		 * Array of chained events that will get executed sequentually.
		 * 
		 * @var Array
		 */
		chains var arrChainedEvents : Array = [];
		
		/**
		 * Constant to be used for representing a set of chained events.
		 * 
		 * @var String
		 */
		chains static const CHAIN : String = "com.a24studio.cairngormchains.control.ChainEvent.chain"; 
		
		/**
		 * Constructor for the generic cairngorm chains event. This event should be derived from
		 * instead of directly used. chainEvents however can be used directly as it is intended to
		 * chain multiple events together easily.
		 * 
		 * @param String type The type of this event.
		 * @param Array arrResponders The array of responders that should be notified when the corresponding commands complete. Defaults to null.
		 * @param Boolean bubbles Whether the event should bubble up. Defaults to false.
		 * @param Boolean cancelable Whether the event can be cancelled, defaults to false.
		 */ 
		public function ChainEvent( type : String, arrResponders : Array = null, bubbles : Boolean = false, cancelable : Boolean = false ) {
			super( type, bubbles, cancelable );
			
			if ( arrResponders == null ) {
				arrResponders = [ ];
			}
			this.arrResponders = arrResponders;
		}
		
		/**
		 * Generates a generic chain event using the provided responder as a global responder and using 
		 * each further argument as an event that should be chained onto the previous one.
		 * 
		 * @param IResponder responder The responder to be used as a global responder and notified after each event has been completed.
		 * @param ChainEvent ...args Each extra argument will be used as an individual chain event and will only be added to the queue if it infact a ChainEvent.
		 * 
		 * @return ChainEvent
		 */
		public static function chainEvents( responder : IResponder, ...args ) : ChainEvent {
			var evt : ChainEvent = new ChainEvent( CHAIN, [ responder ] );
			for ( var i : int = 0 ; i < args.length; i++ ) {
				if ( args[i] is ChainEvent ) {
					evt.arrChainedEvents.push( args[i] );
				}
			}
			return evt;
		}
	}
}