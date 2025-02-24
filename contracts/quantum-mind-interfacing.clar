;; Quantum Mind Interfacing Contract

(define-data-var next-interface-id uint u0)

(define-map quantum-interfaces
  { interface-id: uint }
  {
    entity-id: uint,
    quantum-state: (buff 32),
    last-communication: uint
  }
)

(define-public (register-quantum-interface (entity-id uint) (initial-state (buff 32)))
  (let
    ((new-id (+ (var-get next-interface-id) u1)))
    (var-set next-interface-id new-id)
    (ok (map-set quantum-interfaces
      { interface-id: new-id }
      {
        entity-id: entity-id,
        quantum-state: initial-state,
        last-communication: block-height
      }
    ))
  )
)

(define-public (update-quantum-state (interface-id uint) (new-state (buff 32)))
  (let
    ((interface (unwrap! (map-get? quantum-interfaces { interface-id: interface-id }) (err u404))))
    (ok (map-set quantum-interfaces
      { interface-id: interface-id }
      (merge interface {
        quantum-state: new-state,
        last-communication: block-height
      })
    ))
  )
)

(define-read-only (get-quantum-interface (interface-id uint))
  (ok (unwrap! (map-get? quantum-interfaces { interface-id: interface-id }) (err u404)))
)

(define-read-only (get-latest-communication (interface-id uint))
  (ok (get last-communication (unwrap! (map-get? quantum-interfaces { interface-id: interface-id }) (err u404))))
)

