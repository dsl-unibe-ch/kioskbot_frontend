import { PUBLIC_API } from '$env/static/public';
import { error } from '@sveltejs/kit';
import type { PageLoad } from './$types';

export const load = (async () => {
	const res = await fetch(`${PUBLIC_API}/`);
	const sessionID = (await res.json())?.session_id;
	if (!sessionID) {
		error(500, 'Failed to fetch session ID');
	}
	return {
		sessionID
	};
}) satisfies PageLoad;
