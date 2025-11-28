import { PUBLIC_API } from '$env/static/public';
import type { PageLoad } from './$types';

export const load = (async ({ fetch, url }) => {
	const origin = url.searchParams.get('url') || '';
	let sessionID = null;
	try {
		// Attempt to fetch the API root to check if the server is reachable
		const res = await fetch(`${PUBLIC_API}/initialize-agent?origin=${origin}`);
		if (res.ok) {
			sessionID = (await res.json())?.session_id;
			console.log('Session ID:', sessionID);
		}
	} catch (error) {
		sessionID = null;
		console.error(error);
	}
	return {
		sessionID,
		origin
	};
}) satisfies PageLoad;
