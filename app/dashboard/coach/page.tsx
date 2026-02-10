import { createClient } from "@/lib/supabase/server"
import { CoachView } from "@/components/dashboard/coach-view"

export default async function CoachPage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return null

  const [{ data: profile }, { data: assessment }, { data: chatSessions }] =
    await Promise.all([
      supabase.from("profiles").select("*").eq("id", user.id).single(),
      supabase
        .from("health_assessments")
        .select("*")
        .eq("user_id", user.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .single(),
      supabase
        .from("chat_sessions")
        .select("*")
        .eq("user_id", user.id)
        .order("updated_at", { ascending: false }),
    ])

  return (
    <CoachView
      userId={user.id}
      profile={profile}
      assessment={assessment}
      chatSessions={chatSessions || []}
    />
  )
}
