use provisioning;
set autocommit=0;

drop procedure if exists tmp_update_lnp_rwr_preferences;

delimiter ;;
create procedure tmp_update_lnp_rwr_preferences() begin

  declare _contracts_done, _events_done, _mappings_done boolean default false;
  declare _contract_id, _profile_id, _network_id int(11) unsigned;
  declare _t datetime;
  declare _rank decimal(13,3);

  declare contracts_cur cursor for select contract_id
    from billing_mappings bm group by contract_id;
  declare continue handler for not found set _contracts_done = true;

  open contracts_cur;
  contracts_loop: loop
    fetch contracts_cur into _contract_id;
    if _contracts_done then
      leave contracts_loop;
    end if;
    nested1: begin

      declare events_cur cursor for select distinct t from (
        (select coalesce(start_date,from_unixtime(0)) as t from billing_mappings where contract_id = _contract_id)
        union all
        (select coalesce(end_date,from_unixtime(2147483647)) as t from billing_mappings where contract_id = _contract_id)
      ) as events order by t;
      declare continue handler for not found set _events_done = true;

      set _events_done = false;
      open events_cur;
      events_loop: loop
        fetch events_cur into _bm_id, _t;
        if _events_done then
          leave events_loop;
        end if;

        nested2: begin

          declare mappings_cur cursor for select (rank + unix_timestamp(start_date)) as effective_start_date, billing_profile_id, network_id
            from (select _rank := _rank + 0.001 as rank, start_date, billing_profile_id, network_id from
              billing_mappings where start_date = (select start_date
              from billing_mappings where
              contract_id = _contract_id
              and (start_date <= _t or start_date is null)
              and (end_date >= _t or end_date is null)
              order by start_date desc, id desc limit 1) order by id
            ) order by effective_start_date;
          declare continue handler for not found set _mappings_done = true;

          set _rank = 0.0;
          set _mappings_done = false;
          open mappings_cur;
          mappings_loop: loop
            fetch mappings_cur into _profile_id, _network_id;
            if _mappings_done then
              leave mappings_loop;
            end if;

            INSERT......
            
          end loop mappings_loop;
          close mappings_cur;
        end nested2;
      end loop events_loop;
      close events_cur;
    end nested1;
  end loop contracts_loop;
  close contracts_cur;
end;;
delimiter ;

call tmp_update_lnp_rwr_preferences();

drop procedure tmp_update_lnp_rwr_preferences;

commit;

