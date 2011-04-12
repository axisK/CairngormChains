package com.a24studio.cairngormchains.control {
	import com.a24studio.cairngormchains.chains;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	
	/**
	 * This class will use things in the internal chains namespace. Anything that is not declared
	 * as public, private or protected will be inside this namespace.
	 */
	use namespace chains;
	
	/**
	 * Generic cairngorm chains command. It provides functionality to run multiple events 
	 * that have been chained together in a sequential order and let defined responders know
	 * about their completion.
	 * 
	 * @author Petrus Rademeyer
	 * @since 12 April 2011
	 */ 
	public class ChainCommand implements ICommand {
		/**
		 * The chain events attached to this chain command instance.
		 * 
		 * @var ChainEvent
		 */
		private var relatedEvent : ChainEvent = null;
		
		/**
		 * ICommand implementation for executing commands, the ChainCommand only supports
		 * linking to a ChainEvent or an event derived from it. If the ChainEvent is one
		 * representing a chain of events we start executing them sequentually.
		 * 
		 * @param CairngormEvent event The cairngorm event configured against this command.
		 * 
		 * @throws Error When a non ChainEvent is configured against this command.
		 * @return void
		 */
		public function execute( event : CairngormEvent ) : void {
			//Make sure we don't have a non chain event.
			if ( ! event is ChainEvent ) {
				throw new Error( 'A24CairngormCommands can only be configured to work with A24CairngormEvents' );
			} else {
				//Save the casted event for later use
				relatedEvent = event as ChainEvent;
				
				//If it is a chain - start execution.
				if ( relatedEvent.type == ChainEvent.CHAIN ) {
					executeChain( );
				}
			}
		}
		
		/**
		 * Retrieves the event to be executed by shifting one from the array if there are any.
		 * Attaches a responder to the event that will continue execution on the next link once
		 * this one is completed.
		 * 
		 * @return void 
		 */
		chains function executeChain( ) : void {
			//Make sure the event is actually a chain and make sure that there are still chained events left.
			if ( relatedEvent.type == ChainEvent.CHAIN && relatedEvent.arrChainedEvents.length != 0 ) {
				//Get the next one to run
				var evt: ChainEvent = relatedEvent.arrChainedEvents.shift( ) as ChainEvent;
				//Add a responder to it so we can continue afterwards.
				evt.arrResponders.push( new Responder( this.subCommandSuccessfulHandler, this.subCommandFailedHandler) );
				//Dispatch it
				evt.dispatch( );
			}
		}
		
		/**
		 * Result handler that will let all responders know that the command executed successfuly.
		 * It will provide the attached data object to those responder functions so that they can
		 * optionally stop execution by throwing the appropriate exception.
		 * 
		 * @param Object data Data object containing the result.
		 * 
		 * @return void
		 */
		public function result( data : Object ) : void {
			if ( relatedEvent.arrResponders != null && relatedEvent.arrResponders.length != 0 ) {
				//Loop over the responders
				for ( var i : int = 0; i < relatedEvent.arrResponders.length; i++ ) {
					var objResponder : IResponder = relatedEvent.arrResponders[ i ];
					try {
						//And let each one know that we're done.
						objResponder.result( data );
					} catch ( e : ChainError ) {
						//error thrown by responder result handler indicating that we want to stop execution
						break;
					}
				}
			}
		}
		
		/**
		 * Fault handler that will let all responders know that the command executed unsuccessfuly.
		 * It will provide the attached info object to those responder functions so that they can
		 * optionally stop execution by throwing the appropriate exception.
		 * 
		 * @param Object info Object containing the result.
		 * 
		 * @return void
		 */
		public function fault( info : Object ) : void {
			if ( relatedEvent.arrResponders != null && relatedEvent.arrResponders.length != 0 ) {
				//Loop over the configured responders.
				for ( var i : int = 0; i < relatedEvent.arrResponders.length; i++ ) {
					var objResponder : IResponder = relatedEvent.arrResponders[ i ];
					try {
						objResponder.fault( info );
					} catch ( e : ChainError ) {
						//error thrown by responder result handler indicating that we want to stop execution
						break;
					}
				}
			}
		}
		
		/**
		 * Cairngorm chains result handler that should idealy be run last of all responders.
		 * This will start the execution of the next link in the chain.
		 * 
		 * @param Object data Data object containing the result.
		 * 
		 * @return void
		 */
		private function subCommandSuccessfulHandler( data : Object ) : void {
			if ( relatedEvent.type == ChainEvent.CHAIN ) {
				executeChain( );
			}
		}
		
		/**
		 * Cairngorm chains fault handler that should idealy be run last of all responders.
		 * This will throw an exception to make sure that execution stops and we do not go to the next link
		 * in the chain.
		 * 
		 * @param Object info Object containing the result.
		 * 
		 * @throws ChainError
		 * @return void
		 */
		private function subCommandFailedHandler( info : Object ) : void {
			throw new ChainError( );
		}
	}
}