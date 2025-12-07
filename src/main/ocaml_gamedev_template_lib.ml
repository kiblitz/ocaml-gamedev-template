open! Core

let run () =
  let pool = Domainslib.Task.setup_pool ~num_domains:2 () in
  let result =
    Domainslib.Task.run pool (fun () ->
      let wait_ten = Comms.create () in
      let main__promise =
        Domainslib.Task.async pool (fun () ->
          let%map.Or_error () = Main.run ~wait_ten in
          Comms.kill wait_ten)
      in
      let wait_ten__promise =
        Domainslib.Task.async pool (fun () -> Wait_ten.run wait_ten)
      in
      let%map.Or_error () = Domainslib.Task.await pool main__promise
      and () = Domainslib.Task.await pool wait_ten__promise in
      ())
  in
  Domainslib.Task.teardown_pool pool;
  result
;;
