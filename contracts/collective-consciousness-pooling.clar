;; Collective Consciousness Pooling Contract

(define-data-var next-pool-id uint u0)

(define-map consciousness-pools
  { pool-id: uint }
  {
    members: (list 100 uint),
    collective-level: uint,
    created-at: uint
  }
)

(define-public (create-consciousness-pool (initial-members (list 100 uint)))
  (let
    ((new-id (+ (var-get next-pool-id) u1)))
    (var-set next-pool-id new-id)
    (ok (map-set consciousness-pools
      { pool-id: new-id }
      {
        members: initial-members,
        collective-level: u0,
        created-at: block-height
      }
    ))
  )
)

(define-public (join-consciousness-pool (pool-id uint) (entity-id uint))
  (let
    ((pool (unwrap! (map-get? consciousness-pools { pool-id: pool-id }) (err u404))))
    (ok (map-set consciousness-pools
      { pool-id: pool-id }
      (merge pool {
        members: (unwrap! (as-max-len? (append (get members pool) entity-id) u100) (err u401))
      })
    ))
  )
)

(define-public (update-collective-level (pool-id uint) (new-level uint))
  (let
    ((pool (unwrap! (map-get? consciousness-pools { pool-id: pool-id }) (err u404))))
    (ok (map-set consciousness-pools
      { pool-id: pool-id }
      (merge pool {
        collective-level: new-level
      })
    ))
  )
)

(define-read-only (get-consciousness-pool (pool-id uint))
  (ok (unwrap! (map-get? consciousness-pools { pool-id: pool-id }) (err u404)))
)

(define-read-only (get-pool-size (pool-id uint))
  (ok (len (get members (unwrap! (map-get? consciousness-pools { pool-id: pool-id }) (err u404)))))
)

