(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters   (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect       (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )

    (:action robotMove
      :parameters   (?r - robot ?lstart - location ?lend - location) 
      :precondition (and (at ?r ?lstart) (not(at ?r ?lend)) (no-robot ?lend) (connected ?lstart ?lend))
      :effect       (and (no-robot ?lstart) (not (no-robot ?lend)) (not (at ?r ?lstart)) (at ?r ?lend))
   )

   (:action robotMoveWithPallette
      :parameters   (?r - robot ?p - pallette ?lstart - location ?lend - location)
      :precondition (and (at ?r ?lstart) (no-robot ?lend) (not (no-robot ?lstart)) (at ?p ?lstart) (no-pallette ?lend) (not (no-pallette ?lstart)) (connected ?lstart ?lend))
      :effect       (and (not (at ?r ?lstart)) (at ?r ?lend) (no-robot ?lstart) (not (no-robot ?lend)) (not (at ?p ?lstart)) (at ?p ?lend) (no-pallette ?lstart) (not (no-pallette ?lend)))
   )

   (:action moveItemFromPalletteToShipment
      :parameters   (?s - shipment ?o - order ?l - location ?p - pallette ?si - saleitem)
      :precondition (and (contains ?p ?si) (not (includes ?s ?si)) (orders ?o ?si) (at ?p ?l) (packing-at ?s ?l) (ships ?s ?o))
      :effect       (and (not (contains ?p ?si)) (includes ?s ?si) (not (orders ?o ?si)))
   )

   (:action completeShipment
      :parameters   (?s - shipment ?o - order ?l - location)
      :precondition (and (packing-location ?l) (not (complete ?s)) (not (available ?l)) (packing-at ?s ?l) (ships ?s ?o) (started ?s))
      :effect       (and (not (packing-at ?s ?l)) (complete ?s) (available ?l))   
   )
   
)
