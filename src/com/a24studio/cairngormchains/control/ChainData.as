package com.a24studio.cairngormchains.control {
	/**
	 * Chain data object that we will send to responders indicating success or failure
	 * of an event/command. This is so that we're able to easily indicate which event/command
	 * has failed inside of a chain.
	 * 
	 * @author Petrus Rademeyer
	 * @since 16 April 2011
	 */
	public class ChainData {
		/**
		 * The chain event that was fired.
		 * 
		 * @var ChainEvent
		 */
		public var objEvent : ChainEvent = null;
		
		/**
		 * the chain command that responded to the event.
		 * 
		 * @var ChainCommand
		 */
		public var objCommand : ChainCommand = null;
		
		/**
		 * The data object that should be interpretted by the responder's handler function.
		 * 
		 * @var Object
		 */
		public var objData : Object = null;
		
		/**
		 * Whether the chain command was successful or not.
		 * 
		 * @var Boolean
		 */
		public var bSuccessful : Boolean = false;
		
		/**
		 * Constructor.
		 * 
		 * @param ChainEvent objEvent The chain event that this chain data object is associated with. 
		 * @param ChainCommand objCommand The chain command that responded to the provided event.
		 * @param Object objData The data object that should be handled by the responder's function.
		 * @param Boolean bSuccessful Whether the data object is associated with a successful or failed result.
		 */
		public function ChainData( objEvent : ChainEvent, objCommand : ChainCommand, objData : Object, bSuccessful : Boolean ) {
			this.objEvent = objEvent;
			this.objCommand = objCommand;
			this.objData = objData;
			this.bSuccessful = bSuccessful;
		}
	}
}