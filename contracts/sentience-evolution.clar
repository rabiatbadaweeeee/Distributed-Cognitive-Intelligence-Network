;; Sentience Evolution Contract

(define-data-var next-evolution-id uint u0)

(define-map evolution-processes
  { evolution-id: uint }
  {
    entity-id: uint,
    target-level: uint,
    current-progress: uint,
    started-at: uint,
    status: (string-ascii 20)
  }
)

(define-public (start-evolution-process (entity-id uint) (target-level uint))
  (let
    ((new-id (+ (var-get next-evolution-id) u1)))
    (var-set next-evolution-id new-id)
    (ok (map-set evolution-processes
      { evolution-id: new-id }
      {
        entity-id: entity-id,
        target-level: target-level,
        current-progress: u0,
        started-at: block-height,
        status: "in-progress"
      }
    ))
  )
)

(define-public (update-evolution-progress (evolution-id uint) (progress uint))
  (let
    ((process (unwrap! (map-get? evolution-processes { evolution-id: evolution-id }) (err u404))))
    (ok (map-set evolution-processes
      { evolution-id: evolution-id }
      (merge process {
        current-progress: progress,
        status: (if (>= progress (get target-level process)) "completed" "in-progress")
      })
    ))
  )
)

(define-read-only (get-evolution-process (evolution-id uint))
  (ok (unwrap! (map-get? evolution-processes { evolution-id: evolution-id }) (err u404)))
)

(define-read-only (is-evolution-complete (evolution-id uint))
  (let
    ((process (unwrap! (map-get? evolution-processes { evolution-id: evolution-id }) (err u404))))
    (ok (is-eq (get status process) "completed"))
  )
)

