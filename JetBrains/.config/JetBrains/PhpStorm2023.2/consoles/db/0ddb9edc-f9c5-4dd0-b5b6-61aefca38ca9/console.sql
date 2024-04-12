select
    *
from
    `users`
where
    exists (
        select
            *
        from
            `branches`
        where
                `users`.`branch_id` = `branches`.`id`
          and `branches`.`deleted_at` is null
        order by
            `name` asc
    )
