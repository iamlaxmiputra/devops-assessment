
INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),
    (
        ARRAY[
            '11111111-1111-4111-8111-111111111111',
            '22222222-2222-4222-8222-222222222222',
            '33333333-3333-4333-8333-333333333333'
        ]::UUID[]
    )[1 + (g % 3)],
    'HOTEL-' || LPAD(g::TEXT, 3, '0'),
    (
        ARRAY['delhi', 'mumbai', 'bangalore', 'pune']
    )[1 + (g % 4)],
    CURRENT_DATE + ((g % 60) - 10),
    CURRENT_DATE + ((g % 60) - 10) + 3,
    (1000 + (g * 137 % 15000))::NUMERIC(12,2),
    (
        ARRAY['confirmed', 'cancelled', 'pending', 'completed']
    )[1 + (g % 4)],
    CURRENT_TIMESTAMP - ((g % 60) || ' days')::INTERVAL
FROM generate_series(1, 120) AS g;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    b.id,
    CASE
        WHEN n = 1 THEN 'booking_created'
        ELSE 'booking_updated'
    END,
    jsonb_build_object(
        'source', 'assessment_seed',
        'sequence', n
    ),
    b.created_at + (n || ' hours')::INTERVAL
FROM (
    SELECT id, created_at
    FROM hotel_bookings
    ORDER BY created_at DESC
    LIMIT 40
) AS b
CROSS JOIN generate_series(1, 2) AS n;
